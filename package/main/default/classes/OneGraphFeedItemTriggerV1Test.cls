@isTest
private class OneGraphFeedItemTriggerV1Test {
  @isTest
  static void testFeedCommentTrigger() {
    new MockUtils().mockHttp();
    Case c = new Case();
    insert c;
    Test.startTest();
    FeedItem fi = new FeedItem();
    fi.Body = 'Body';
    fi.ParentId = c.Id;
    insert fi;
    System.assert(1 == Limits.getQueueableJobs(), 'job was not queued');
    Test.stopTest();
  }
}
