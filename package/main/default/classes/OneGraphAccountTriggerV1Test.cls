@isTest
private class OneGraphAccountTriggerV1Test {
  @isTest
  static void testAccountTrigger() {
    new MockUtils().mockHttp();
    Test.startTest();
    Account a = new Account();
    a.Name = 'Account';
    insert a;
    System.assertEquals(Limits.getQueueableJobs(), 1, 'job was not queued');
    Test.stopTest();
  }
}
