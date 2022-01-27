@isTest
private class OneGraphLeadTriggerV1Test {
  @isTest
  static void testLeadTrigger() {
    new MockUtils().mockHttp();
    Test.startTest();
    Lead o = new Lead();
    o.FirstName = 'FirstName';
    o.LastName = 'LastName';
    o.Company = 'Company';
    insert o;
    System.assertEquals(Limits.getQueueableJobs(), 1, 'job was not queued');
    Test.stopTest();
  }
}
