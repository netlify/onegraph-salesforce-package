@isTest
private class TriggerFilterPublicTest {
  @isTest
  static void doGetTest() {
    Test.startTest();
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();

    req.requestURI = '/trigger-filters';
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;

    TriggerFilterPublic.doGet();

    Test.stopTest();

    Map<String, Object> jsonBody = (Map<String, Object>) JSON.deserializeUntyped(
      res.responseBody.toString()
    );

    List<Object> filters = (List<Object>) jsonBody.get('filters');

    System.assertEquals(0, filters.size(), 'Returns an empty list of filters');
  }

  @isTest
  static void doGetTestWithFilter() {
    OneGraph__TriggerFilter__c row = new OneGraph__TriggerFilter__c();
    row.OneGraph__Serialized_filter__c = '{}';
    row.OneGraph__SObject_Name__c = 'Opportunity';
    insert row;

    Test.startTest();
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();

    req.requestURI = '/trigger-filters';
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;

    TriggerFilterPublic.doGet();

    Test.stopTest();

    Map<String, Object> jsonBody = (Map<String, Object>) JSON.deserializeUntyped(
      res.responseBody.toString()
    );

    List<Object> filters = (List<Object>) jsonBody.get('filters');

    System.assertEquals(1, filters.size(), 'Returns the filter');

    String sobjectName = (String) (((Map<String, Object>) filters[0])
      .get('sobjectName'));
    System.assertEquals('Opportunity', sobjectName, 'Returns the right data');
  }

  @isTest
  static void doPutTest() {
    Test.startTest();
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();

    req.requestURI = '/trigger-filters';
    req.httpMethod = 'PUT';
    req.requestBody = Blob.valueOf(
      '{"filters": [{"sobjectName": "Opportunity", "filter": "{}"}]}'
    );
    RestContext.request = req;
    RestContext.response = res;

    TriggerFilterPublic.doPut();

    Test.stopTest();

    Map<String, Object> jsonBody = (Map<String, Object>) JSON.deserializeUntyped(
      res.responseBody.toString()
    );

    List<Object> filters = (List<Object>) jsonBody.get('filters');

    System.assertEquals(1, filters.size(), 'Returns the filter');

    String sobjectName = (String) (((Map<String, Object>) filters[0])
      .get('sobjectName'));
    System.assertEquals('Opportunity', sobjectName, 'Returns the right data');

    List<OneGraph__TriggerFilter__c> filterRows = [
      SELECT OneGraph__Serialized_filter__c, OneGraph__SObject_Name__c
      FROM OneGraph__TriggerFilter__c
    ];

    System.assertEquals(1, filterRows.size(), 'Inserts the filter');

    System.assertEquals(
      'Opportunity',
      filterRows[0].OneGraph__SObject_Name__c,
      'Inserts the filter'
    );
  }

  @isTest
  static void doDeleteTest() {
    OneGraph__TriggerFilter__c row = new OneGraph__TriggerFilter__c();
    row.OneGraph__Serialized_filter__c = '{}';
    row.OneGraph__SObject_Name__c = 'Opportunity';
    insert row;

    Test.startTest();
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();

    req.requestURI = '/trigger-filters';
    req.httpMethod = 'DELETE';
    req.requestBody = Blob.valueOf('{"sobjectNames": ["Opportunity"]}');
    RestContext.request = req;
    RestContext.response = res;

    TriggerFilterPublic.doDelete();

    Test.stopTest();

    Map<String, Object> jsonBody = (Map<String, Object>) JSON.deserializeUntyped(
      res.responseBody.toString()
    );

    List<Object> filters = (List<Object>) jsonBody.get('filters');

    System.assertEquals(0, filters.size(), 'Deletes the filter');
  }
}
