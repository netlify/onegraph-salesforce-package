@isTest
private class OneGraphQuoteTriggerV1Test {
  @isTest
  static void testQuoteTrigger() {
    Test.startTest();
    Opportunity o = new Opportunity();
    o.Name = 'Name';
    o.StageName = 'Closed Won';
    o.CloseDate = System.today();
    insert o;
 
    Quote q = new Quote();
    q.Name = 'Name';
    q.OpportunityId = o.Id;
    insert q;
    Test.stopTest();
  }
}
