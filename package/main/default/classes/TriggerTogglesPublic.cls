@RestResource(urlMapping='/trigger-toggles')
global class TriggerTogglesPublic {
  private class PackageVersion {
    public String versionString;

    public PackageVersion(String versionString) {
      this.versionString = versionString;
    }
  }

  private class Response {
    public PackageVersion packageVersion;
    public OneGraphToggleSettings.ToggleSettings toggles;

    public Response(
      PackageVersion packageVersion,
      OneGraphToggleSettings.ToggleSettings toggles
    ) {
      this.packageVersion = packageVersion;
      this.toggles = toggles;
    }
  }

  private static Response makeResponse(OneGraph__TriggerToggle__c toggle) {
    return new Response(
      new PackageVersion(OneGraphPackageVersion.versionString),
      OneGraphToggleSettings.getAllSettings(toggle)
    );
  }

  @HttpGet
  global static void doGet() {
    OneGraph__TriggerToggle__c triggerToggles = OneGraph__TriggerToggle__c.getOrgDefaults();
    RestContext.response.addHeader('Content-Type', 'application/json');
    RestContext.response.responseBody = Blob.valueOf(
      JSON.serialize(makeResponse(triggerToggles))
    );
  }

  private class Setting {
    public String sobjectName;
    public String triggerName;
    public Boolean disable;
  }

  private class DisableAllSetting {
    public String sobjectName;
    public Boolean disable;
  }

  private class PutBody {
    public Boolean disableAll;
    public List<DisableAllSetting> disableAllSobjectSettings;
    public List<Setting> sobjectTriggerSettings;
  }

  private static OneGraph__TriggerToggle__c runUpdate(PutBody putBody) {
    OneGraph__TriggerToggle__c toggle = OneGraph__TriggerToggle__c.getOrgDefaults();

    if (toggle.Name == null) {
      toggle = new OneGraph__TriggerToggle__c();
    }

    if (putBody.disableAll != null) {
      toggle.Disable_All_Triggers__c = putBody.disableAll;
    }

    if (putBody.disableAllSobjectSettings != null) {
      for (DisableAllSetting setting : putBody.disableAllSobjectSettings) {
        OneGraphToggleSettings.setAllForSobject(
          toggle,
          setting.sobjectName.toLowerCase(),
          setting.disable
        );
      }
    }

    if (putBody.sobjectTriggerSettings != null) {
      for (Setting setting : putBody.sobjectTriggerSettings) {
        OneGraphToggleSettings.setTriggerForSobject(
          toggle,
          setting.sobjectName.toLowerCase(),
          setting.triggerName.toLowerCase(),
          setting.disable
        );
      }
    }

    if (toggle.Name == null) {
      insert toggle;
    } else {
      update toggle;
    }

    return toggle;
  }

  @HttpPut
  global static void doPut() {
    RestRequest req = RestContext.request;
    PutBody putBody = (PutBody) JSON.deserialize(
      req.requestBody.toString(),
      PutBody.class
    );
    OneGraph__TriggerToggle__c toggle = runUpdate(putBody);

    RestContext.response.addHeader('Content-Type', 'application/json');
    RestContext.response.responseBody = Blob.valueOf(
      JSON.serialize(makeResponse(toggle))
    );
  }
}
