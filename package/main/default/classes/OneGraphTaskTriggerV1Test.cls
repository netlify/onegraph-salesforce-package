@isTest
private class OneGraphTaskTriggerV1Test {
  @isTest
  static void testTaskTrigger() {
    new MockUtils().mockHttp();
    Test.startTest();
    Task o = new Task();
    o.Subject = 'Subject';
    insert o;
    System.assertEquals(Limits.getQueueableJobs(), 1, 'job was not queued');
    Test.stopTest();
  }
}
