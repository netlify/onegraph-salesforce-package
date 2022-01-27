@isTest
private class OneGraphContactTriggerV1Test {
  @isTest
  static void testContactTrigger() {
    new MockUtils().mockHttp();
    Test.startTest();
    Contact o = new Contact();
    o.LastName = 'Contact';
    insert o;
    System.assertEquals(Limits.getQueueableJobs(), 1, 'job was not queued');
    Test.stopTest();
  }
}
