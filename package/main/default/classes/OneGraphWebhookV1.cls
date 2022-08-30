@namespaceAccessible
public class OneGraphWebhookV1 implements Queueable, Database.AllowsCallouts {
  private String deliveryId;
  @TestVisible
  private static String transactionIdStatic;
  private static Integer triggerIndexStatic = -1;
  private String transactionId;
  private Integer triggerIndex;
  private String content;
  private String sobjectName;
  private String triggerType;
  private Integer attempts = 0;
  private Integer maxAttempts = 3;
  private Integer cpuTime = 0;
  // Will be set to true if we know we will exceed
  // execution limits on transaction if we continue
  @TestVisible
  private static Boolean isFinalExecution = false;
  public Boolean shouldExecute = true;
  private static String webhookErrorMessage = 'Error from OneGraph';
  @TestVisible
  private static Boolean sendCalloutDuringTest = false;
  private Boolean isFirstRun = true;
  // Will be true if the sobject might be a setup object, indicating that we
  // shouldn't do any DML operations to avoid mixed_dml_operations errors
  // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_dml_non_mix_sobjects.htm
  private Boolean isSetupObject = false;
  private String triggerFilterError;

  @TestVisible
  private static Void writeBool(
    JSONGenerator gen,
    String fieldName,
    Boolean b
  ) {
    if (b != null) {
      gen.writeBooleanField(fieldName, b);
    } else {
      gen.writeNullField(fieldName);
    }
  }

  @TestVisible
  private static Void writeObject(
    JSONGenerator gen,
    String fieldName,
    Object o
  ) {
    if (o != null) {
      gen.writeObjectField(fieldName, o);
    } else {
      gen.writeNullField(fieldName);
    }
  }

  @TestVisible
  private static Void writeInt(JSONGenerator gen, String fieldName, Integer i) {
    if (i != null) {
      gen.writeNumberField(fieldName, i);
    } else {
      gen.writeNullField(fieldName);
    }
  }

  @TestVisible
  private static Void writeString(
    JSONGenerator gen,
    String fieldName,
    String s
  ) {
    if (s != null) {
      gen.writeStringField(fieldName, s);
    } else {
      gen.writeNullField(fieldName);
    }
  }

  @TestVisible
  private static String getTriggerType(System.TriggerOperation o) {
    switch on o {
      when AFTER_INSERT {
        return 'insert';
      }
      when AFTER_UPDATE {
        return 'update';
      }
      when AFTER_DELETE {
        return 'delete';
      }
      when AFTER_UNDELETE {
        return 'undelete';
      }
      when else {
        return null;
      }
    }
  }

  @TestVisible
  private static String getJsonContent(
    List<Object> n,
    List<Object> o,
    Integer size,
    String sobjectName,
    String triggerType
  ) {
    JSONGenerator gen = JSON.createGenerator(false); // true -> pretty
    gen.writeStartObject();
    writeInt(gen, 'size', size);
    writeString(gen, 'userId', UserInfo.getUserId());
    writeString(gen, 'sobjectName', sobjectName);
    writeString(gen, 'trigger', triggerType);
    writeBool(gen, 'mayHaveUnsentPayloads', OneGraphWebhookV1.isFinalExecution);
    writeObject(gen, 'new', n);
    writeObject(gen, 'old', o);
    gen.writeEndObject();
    gen.close();
    return gen.getAsString();
  }

  private Boolean hasJobs() {
    return (Limits.getLimitQueueableJobs() - Limits.getQueueableJobs()) > 0;
  }

  private static Void cleanupTransactionMeta() {
    Datetime now = Datetime.now();
    Datetime cleanupThreshold = now.addMinutes(-20);

    OneGraph__Transaction_Meta__c[] cleanupMeta = [
      SELECT Id
      FROM OneGraph__Transaction_Meta__c
      WHERE SystemModstamp < :cleanupThreshold
    ];
    if (cleanupMeta.size() > 0) {
      try {
        delete cleanupMeta;
      } catch (DmlException e) {
        if (e.getDmlType(0) != StatusCode.ENTITY_IS_DELETED) {
          System.debug(
            LoggingLevel.ERROR,
            'Error cleaning up metadata ' + e.getMessage()
          );
        }
      } catch (Exception e) {
        System.debug(
          LoggingLevel.ERROR,
          'Error cleaning up metadata ' + e.getMessage()
        );
      }
    }
  }

  private static Boolean checkIsSetupObject(String sobjectName) {
    // We could be a bit more sophisticated here and check some constaints on user
    // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_dml_non_mix_sobjects.htm
    return sobjectName == 'User';
  }

  @namespaceAccessible
  public OneGraphWebhookV1(string sobjectName, System.TriggerOperation op) {
    Integer startCpu = Limits.getCpuTime();
    this.triggerType = getTriggerType(op);
    this.sobjectName = sobjectName;

    if (OneGraphWebhookV1.isFinalExecution) {
      System.debug(
        LoggingLevel.WARN,
        'Too many jobs queueud for this transaction, refusing to enqueue another.'
      );
      this.shouldExecute = false;
    } else if (!hasJobs()) {
      System.debug(
        LoggingLevel.ERROR,
        'Too many jobs queueud for this transaction, refusing to enqueue another. sobjectName=' +
        sobjectName +
        ', triggerType=' +
        triggerType
      );
      this.shouldExecute = false;
    } else {
      Integer jobsMax = Limits.getLimitQueueableJobs();
      Integer jobsCreated = Limits.getQueueableJobs();
      if (jobsCreated > jobsMax / 2) {
        System.debug(
          LoggingLevel.WARN,
          'Already using half the available jobs, this will be the last job we enqueue for the transaction.'
        );
        OneGraphWebhookV1.isFinalExecution = true;
      }
    }
    if (
      !OneGraphToggleSettings.shouldExecuteForTrigger(
        sobjectName,
        triggerType,
        UserInfo.getUserId()
      )
    ) {
      System.debug(
        LoggingLevel.DEBUG,
        'Skipping execution for trigger via custom setting.'
      );
      this.shouldExecute = false;
    }
    if (this.shouldExecute) {
      TriggerFilter.FilteredTrigger filteredTrigger = TriggerFilter.filterTrigger(
        Trigger.old,
        Trigger.new,
        Trigger.size,
        sobjectName
      );

      this.triggerFilterError = filteredTrigger.error;

      if (filteredTrigger.size == 0) {
        this.shouldExecute = false;
      } else {
        this.content = getJsonContent(
          filteredTrigger.newFiltered,
          filteredTrigger.oldFiltered,
          filteredTrigger.size,
          sobjectName,
          triggerType
        );

        this.isSetupObject = checkIsSetupObject(sobjectName);

        if (OneGraphWebhookV1.transactionIdStatic != null) {
          this.isFirstRun = false;
        } else {
          OneGraphWebhookV1.transactionIdStatic = EncodingUtil.ConvertTohex(
            Crypto.GenerateAESKey(128)
          );
        }

        this.transactionId = OneGraphWebhookV1.transactionIdStatic;

        // Avoids mixed dml errors.
        if (!this.isSetupObject) {
          OneGraphWebhookV1.triggerIndexStatic =
            OneGraphWebhookV1.triggerIndexStatic + 1;
          this.triggerIndex = OneGraphWebhookV1.triggerIndexStatic;
          OneGraph__Transaction_Meta__c meta = new OneGraph__Transaction_Meta__c(
            OneGraph__Transaction_Id__c = OneGraphWebhookV1.transactionIdStatic,
            OneGraph__Max_Trigger_Index__c = OneGraphWebhookV1.triggerIndexStatic
          );
          upsert meta OneGraph__Transaction_Id__c;
        }

        this.deliveryId = EncodingUtil.ConvertTohex(Crypto.GenerateAESKey(128));
      }
    }
    this.cpuTime = Limits.getCpuTime() - startCpu;
  }

  private Boolean isCalloutEnabled() {
    if (Test.isRunningTest() && !sendCalloutDuringTest) {
      return false;
    } else {
      return true;
    }
  }

  private void sendCallout() {
    Integer startCpu = Limits.getCpuTime();
    String orgId = UserInfo.getOrganizationId();
    Long timestamp = DateTime.now().getTime();
    String signature = SigningKey.getSignature(timestamp, content);
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setCompressed(true);
    req.setEndpoint('callout:OneGraph__Callout/webhooks/salesforce');
    req.setMethod('POST');
    req.setHeader('Content-Type', 'application/json');
    req.setHeader('x-salesforce-organization-id', orgId);
    req.setHeader('x-salesforce-attempts', String.valueOf(attempts));
    req.setHeader('x-salesforce-sobject-name', sobjectName);
    req.setHeader('x-salesforce-trigger', triggerType);
    req.setHeader('x-salesforce-delivery-id', deliveryId);
    req.setHeader('x-salesforce-transaction-id', transactionId);
    // Don't send trigger index for setup objects since we skip the triggerIndex
    // handling to avoid mixed dml errors
    if (!this.isSetupObject) {
      req.setHeader('x-salesforce-trigger-index', String.valueOf(triggerIndex));
      OneGraph__Transaction_Meta__c meta = [
        SELECT OneGraph__Max_Trigger_Index__c
        FROM OneGraph__Transaction_Meta__c
        WHERE OneGraph__Transaction_Id__c = :transactionId
      ];
      if (meta != null) {
        req.setHeader(
          'x-salesforce-max-trigger-index',
          String.valueOf(meta.OneGraph__Max_Trigger_Index__c)
        );
      }
    }
    req.setHeader('x-salesforce-first-run', isFirstRun ? 'true' : 'false');
    req.setHeader('x-salesforce-signature', signature);
    req.setBody(content);
    this.cpuTime = this.cpuTime + (Limits.getCpuTime() - startCpu);
    req.setHeader('x-salesforce-cpu-time', String.valueOf(this.cpuTime));
    req.setHeader(
      'x-salesforce-package-version',
      OneGraphPackageVersion.versionString
    );
    if (this.triggerFilterError != null) {
      req.setHeader(
        'x-salesforce-trigger-filter-error',
        this.triggerFilterError.left(255)
      );
    }
    HTTPResponse res = h.send(req);
    if (res.getStatusCode() != 200) {
      System.debug(
        LoggingLevel.ERROR,
        String.format(
          'Error sending webhook to OneGraph, url={0}, statusCode={1}, statusMessage={2}',
          new List<Object>{
            '/webhooks/salesforce',
            res.getStatusCode(),
            res.getStatus()
          }
        )
      );
      CalloutException e = new CalloutException();
      e.setMessage(webhookErrorMessage);
      throw e;
    }
    if (triggerIndex == 0 && attempts == 1) {
      cleanupTransactionMeta();
    }
  }

  private void sendCalloutWithRetries() {
    try {
      attempts = attempts + 1;
      if (isCalloutEnabled()) {
        sendCallout();
      }
    } catch (Exception e) {
      System.debug(
        LoggingLevel.ERROR,
        'Retrying on exception ' + e.getMessage()
      );
      if (attempts >= maxAttempts) {
        System.debug(LoggingLevel.ERROR, 'Too many attempts. Giving up.');
      } else {
        // If it was an error from OneGraph, just make the http request again,
        // otherwise we should requeue a job in case the error is callback after dml
        if (e.getMessage() == webhookErrorMessage) {
          sendCalloutWithRetries();
        } else if (hasJobs()) {
          System.enqueueJob(this);
        } else {
          System.debug(
            LoggingLevel.ERROR,
            'No more queued jobs available. Giving up.'
          );
        }
      }
    }
  }

  @namespaceAccessible
  public void run() {
    Integer startCpu = Limits.getCpuTime();
    if (this.shouldExecute) {
      System.enqueueJob(this);
    }
    this.cpuTime = this.cpuTime + Limits.getCpuTime() - startCpu;
  }

  @namespaceAccessible
  public void execute(QueueableContext context) {
    sendCalloutWithRetries();
  }
}
