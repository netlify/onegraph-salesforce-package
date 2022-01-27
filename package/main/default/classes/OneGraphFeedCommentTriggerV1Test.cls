@isTest
private class OneGraphFeedCommentTriggerV1Test {
  @isTest
  static void testFeedCommentTrigger() {
    new MockUtils().mockHttp();
    Case c = new Case();
    insert c;
    FeedItem fi = new FeedItem();
    fi.Body = 'Body';
    fi.ParentId = c.Id;
    insert fi;
    Test.startTest();
    FeedComment o = new FeedComment();
    o.CommentBody = 'Body';
    o.FeedItemId = fi.Id;
    insert o;
    System.assertEquals(Limits.getQueueableJobs(), 1, 'job was not queued');
    Test.stopTest();
  }
}
