@isTest
private class OneGraphCaseCommentTriggerV1Test {
  @isTest
  static void testCaseCommentTrigger() {
    new MockUtils().mockHttp();
    Case c = new Case();
    insert c;
    Test.startTest();
    CaseComment o = new CaseComment();
    o.ParentId = c.Id;
    insert o;
    System.assertEquals(Limits.getQueueableJobs(), 1, 'job was not queued');
    Test.stopTest();
  }
}
