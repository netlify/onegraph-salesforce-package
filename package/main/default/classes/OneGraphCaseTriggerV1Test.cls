@isTest
private class OneGraphCaseTriggerV1Test {
  @isTest
  static void testCaseTrigger() {
    new MockUtils().mockHttp();
    Test.startTest();
    Case o = new Case();
    insert o;
    System.assertEquals(Limits.getQueueableJobs(), 1, 'job was not queued');
    Test.stopTest();
  }
}
