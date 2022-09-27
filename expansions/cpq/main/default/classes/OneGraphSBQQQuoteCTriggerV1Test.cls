@isTest
private class OneGraphSBQQQuoteCTriggerV1Test {
  @isTest
  static void testSBQQQuoteCTrigger() {
    Test.startTest();
    SBQQ__Quote__c q = new SBQQ__Quote__c();
    insert q;
    Test.stopTest();
  }
}
