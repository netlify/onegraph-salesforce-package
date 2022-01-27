trigger OneGraphFeedCommentTriggerV1 on FeedComment(
  after insert,
  after update,
  after delete,
  after undelete
) {
  OneGraphWebhookV1 job = new OneGraphWebhookV1(
    'FeedComment',
    Trigger.operationType
  );
  job.run();
}
