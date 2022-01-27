@isTest
private class OneGraphEventTriggerV1Test {
  @isTest
  static void testEventTrigger() {
    new MockUtils().mockHttp();
    Test.startTest();
    Event a = new Event();
    a.Subject = 'Call';
    a.DurationInMinutes = 5;
    a.ActivityDateTime = Datetime.now();
    insert a;
    System.assertEquals(Limits.getQueueableJobs(), 1, 'job was not queued');
    Test.stopTest();
  }
}
