@isTest
private class OneGraphOpportunityTriggerV1Test {
  @isTest
  static void testOpportunityTrigger() {
    new MockUtils().mockHttp();
    Test.startTest();
    Opportunity o = new Opportunity();
    o.Name = 'Name';
    o.StageName = 'Closed Won';
    o.CloseDate = System.today();
    insert o;
    System.assertEquals(Limits.getQueueableJobs(), 1, 'job was not queued');
    Test.stopTest();
  }
}
