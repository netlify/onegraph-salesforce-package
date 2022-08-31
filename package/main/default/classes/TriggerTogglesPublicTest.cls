@isTest
private class TriggerTogglesPublicTest {
  @isTest
  static void doGetTest() {
    Test.startTest();
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();

    req.requestURI = '/trigger-toggles';
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;

    TriggerTogglesPublic.doGet();

    Test.stopTest();

    Map<String, Object> jsonBody = (Map<String, Object>) JSON.deserializeUntyped(
      res.responseBody.toString()
    );

    Map<String, Object> toggles = (Map<String, Object>) jsonBody.get('toggles');

    Map<String, Object> bySobject = (Map<String, Object>) toggles.get(
      'bySobjectName'
    );

    Map<String, Object> accountSettings = (Map<String, Object>) bySobject.get(
      'Account'
    );

    System.assertEquals(
      false,
      (Boolean) toggles.get('disableAll'),
      'Returns disableAll=false'
    );

    System.assertEquals(
      false,
      (Boolean) accountSettings.get('disableAll'),
      'Returns account.disableAll=false'
    );
  }

  @isTest
  static void doPutTest() {
    Test.startTest();
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();

    req.requestURI = '/trigger-toggles';
    req.httpMethod = 'PUT';
    req.requestBody = Blob.valueOf(
      '{"disableAll": true,' +
      '"disableAllSobjectSettings": [{"sobjectName": "Account", "disable": true}],' +
      '"sobjectTriggerSettings": [{"sobjectName": "Opportunity", "triggerName": "update", "disable": true}]}'
    );
    RestContext.request = req;
    RestContext.response = res;

    TriggerTogglesPublic.doPut();

    Test.stopTest();

    Map<String, Object> jsonBody = (Map<String, Object>) JSON.deserializeUntyped(
      res.responseBody.toString()
    );

    Map<String, Object> toggles = (Map<String, Object>) jsonBody.get('toggles');

    Map<String, Object> bySobject = (Map<String, Object>) toggles.get(
      'bySobjectName'
    );

    Map<String, Object> accountSettings = (Map<String, Object>) bySobject.get(
      'Account'
    );

    Map<String, Object> opportunitySettings = (Map<String, Object>) bySobject.get(
      'Opportunity'
    );

    System.assertEquals(
      true,
      (Boolean) toggles.get('disableAll'),
      'Returns disableAll=true'
    );

    System.assertEquals(
      true,
      (Boolean) accountSettings.get('disableAll'),
      'Returns account.disableAll=true'
    );

    System.assertEquals(
      true,
      (Boolean) opportunitySettings.get('disableUpdate'),
      'Returns opportunity.disableUpdate=true'
    );

    OneGraph__TriggerToggle__c t = OneGraph__TriggerToggle__c.getInstance();

    System.assertEquals(
      true,
      t.Disable_All_Triggers__c,
      'Disable_All_Triggers__c=true'
    );

    System.assertEquals(
      true,
      t.Disable_All_Account_Triggers__c,
      'Disable_All_Account_Triggers__c=true'
    );

    System.assertEquals(
      true,
      t.Disable_Opportunity_Update_Trigger__c,
      'Disable_Opportunity_Update_Trigger__c=true'
    );
  }
}
