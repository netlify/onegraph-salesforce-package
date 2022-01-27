@isTest
private class OneGraphWebhookV1Test {
  @isTest
  static void testJson() {
    JSONGenerator gen = JSON.createGenerator(false);
    gen.writeStartObject();
    OneGraphWebhookV1.writeBool(gen, 'bool', true);
    OneGraphWebhookV1.writeBool(gen, 'nullBool', null);
    OneGraphWebhookV1.writeObject(gen, 'obj', new List<Object>{});
    OneGraphWebhookV1.writeObject(gen, 'nullObj', null);
    OneGraphWebhookV1.writeInt(gen, 'int', 0);
    OneGraphWebhookV1.writeInt(gen, 'nullInt', null);
    OneGraphWebhookV1.writeString(gen, 'string', 's');
    OneGraphWebhookV1.writeString(gen, 'nullString', null);
    gen.writeEndObject();
    gen.close();
    System.assertEquals(
      gen.getAsString(),
      '{"bool":true,"nullBool":null,"obj":[],"nullObj":null,"int":0,"nullInt":null,"string":"s","nullString":null}',
      'invalid json'
    );
  }

  @isTest
  static void testGetTriggerType() {
    System.assertEquals(
      OneGraphWebhookV1.getTriggerType(System.TriggerOperation.AFTER_DELETE),
      'delete',
      'invalid trigger for delete'
    );
    System.assertEquals(
      OneGraphWebhookV1.getTriggerType(System.TriggerOperation.AFTER_INSERT),
      'insert',
      'invalid trigger for insert'
    );
    System.assertEquals(
      OneGraphWebhookV1.getTriggerType(System.TriggerOperation.AFTER_UPDATE),
      'update',
      'invalid trigger for update'
    );
    System.assertEquals(
      OneGraphWebhookV1.getTriggerType(System.TriggerOperation.AFTER_UNDELETE),
      'undelete',
      'invalid trigger for undelete'
    );
    System.assertEquals(
      OneGraphWebhookV1.getTriggerType(System.TriggerOperation.BEFORE_DELETE),
      null,
      'invalid trigger for unhandled'
    );
  }

  @isTest
  static void testGetJsonContent() {
    System.assertEquals(
      OneGraphWebhookV1.getJsonContent(null, null, 0, 'Account', 'insert'),
      '{"size":0,"userId":"' +
      UserInfo.getUserId() +
      '","sobjectName":"Account","trigger":"insert","mayHaveUnsentPayloads":false,"new":null,"old":null}',
      'invalid json content'
    );
  }

  @isTest
  static void testExecute() {
    MockUtils mockUtils = new MockUtils();
    mockUtils.mockHttp();
    Test.startTest();
    OneGraphWebhookV1 job = new OneGraphWebhookV1(
      'Account',
      System.TriggerOperation.AFTER_UPDATE
    );
    job.run();
    System.assertEquals(Limits.getQueueableJobs(), 1, 'job was not queued');
    Test.stopTest();
    System.assertEquals(
      1,
      mockUtils.getWebhookRequests().size(),
      'expected request to send one webhook'
    );
    HttpRequest request = mockUtils.getLastRequest();

    System.assertEquals(
      'true',
      request.getHeader('x-salesforce-first-run'),
      'sets first-run header'
    );
  }

  @isTest
  static void testRetryOnFailure() {
    MockUtils mockUtils = new MockUtils(1);
    mockUtils.mockHttp();
    Test.startTest();
    OneGraphWebhookV1 job = new OneGraphWebhookV1(
      'Account',
      System.TriggerOperation.AFTER_UPDATE
    );

    job.run();
    Test.stopTest();
    System.assertEquals(
      2,
      mockUtils.getWebhookRequests().size(),
      'did not retry request'
    );
  }

  @isTest
  static void testGivesUpAfterEnoughFailures() {
    MockUtils mockUtils = new MockUtils(10);
    mockUtils.mockHttp();
    Test.startTest();
    OneGraphWebhookV1 job = new OneGraphWebhookV1(
      'Account',
      System.TriggerOperation.AFTER_UPDATE
    );
    job.run();
    Test.stopTest();
    System.assertEquals(
      3,
      mockUtils.getWebhookRequests().size(),
      'did not retry request'
    );
  }

  @isTest
  static void testRespectsLimitsIfFinalAlreadySet() {
    MockUtils mockUtils = new MockUtils(10);
    mockUtils.mockHttp();
    Test.startTest();
    OneGraphWebhookV1.isFinalExecution = true;
    OneGraphWebhookV1 job = new OneGraphWebhookV1(
      'Account',
      System.TriggerOperation.AFTER_UPDATE
    );
    job.run();
    System.assertEquals(
      0,
      Limits.getQueueableJobs(),
      'job should not have been added to queue'
    );
    Test.stopTest();
    System.assertEquals(
      0,
      mockUtils.getWebhookRequests().size(),
      'sent a request'
    );
  }

  @isTest
  static void testAbortsIfCustomSettingAbortsAll() {
    MockUtils mockUtils = new MockUtils(10);
    mockUtils.mockHttp();
    Test.startTest();
    OneGraph__TriggerToggle__c triggerToggles = new OneGraph__TriggerToggle__c();
    triggerToggles.Disable_All_Triggers__c = true;
    insert triggerToggles;
    OneGraphWebhookV1 job = new OneGraphWebhookV1(
      'Account',
      System.TriggerOperation.AFTER_UPDATE
    );
    job.run();
    System.assertEquals(
      0,
      Limits.getQueueableJobs(),
      'job should not have been added to queue'
    );
    Test.stopTest();
    System.assertEquals(
      0,
      mockUtils.getWebhookRequests().size(),
      'sent a request'
    );
  }

  @isTest
  static void testAbortsIfCustomSettingAbortsAllForSobject() {
    MockUtils mockUtils = new MockUtils(10);
    mockUtils.mockHttp();
    Test.startTest();
    OneGraph__TriggerToggle__c triggerToggles = new OneGraph__TriggerToggle__c();
    triggerToggles.Disable_All_Account_Triggers__c = true;
    insert triggerToggles;
    OneGraphWebhookV1 job = new OneGraphWebhookV1(
      'Account',
      System.TriggerOperation.AFTER_UPDATE
    );
    job.run();
    System.assertEquals(
      0,
      Limits.getQueueableJobs(),
      'job should not have been added to queue'
    );
    Test.stopTest();
    System.assertEquals(
      0,
      mockUtils.getWebhookRequests().size(),
      'sent a request'
    );
  }

  @isTest
  static void testAbortsIfCustomSettingAbortsForSobjectTrigger() {
    MockUtils mockUtils = new MockUtils(10);
    mockUtils.mockHttp();
    Test.startTest();
    OneGraph__TriggerToggle__c triggerToggles = new OneGraph__TriggerToggle__c();
    triggerToggles.Disable_Account_Update_Trigger__c = true;
    insert triggerToggles;
    OneGraphWebhookV1 job = new OneGraphWebhookV1(
      'Account',
      System.TriggerOperation.AFTER_UPDATE
    );
    job.run();
    System.assertEquals(
      0,
      Limits.getQueueableJobs(),
      'job should not have been added to queue'
    );
    Test.stopTest();
    System.assertEquals(
      0,
      mockUtils.getWebhookRequests().size(),
      'sent a request'
    );
  }

  @isTest
  static void testSetsFirstRunAndTransactionIdOnWorkflowRules() {
    MockUtils mockUtils = new MockUtils();
    mockUtils.mockHttp();
    Test.startTest();
    // It would be better to simulate a workflow rule, but unclear how
    // to set that up in a test.
    OneGraphWebhookV1.transactionIdStatic = 'test';
    OneGraphWebhookV1 job = new OneGraphWebhookV1(
      'Account',
      System.TriggerOperation.AFTER_UPDATE
    );
    job.run();
    System.assertEquals(1, Limits.getQueueableJobs(), 'job was not queued');
    Test.stopTest();
    System.assertEquals(
      1,
      mockUtils.getWebhookRequests().size(),
      'sent a request'
    );

    HttpRequest request = mockUtils.getLastRequest();

    System.assertEquals(
      'test',
      request.getHeader('x-salesforce-transaction-id'),
      'set transaction-id header'
    );

    System.assertEquals(
      'false',
      request.getHeader('x-salesforce-first-run'),
      'set first-run header'
    );
  }
}
