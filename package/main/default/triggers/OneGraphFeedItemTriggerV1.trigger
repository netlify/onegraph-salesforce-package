trigger OneGraphFeedItemTriggerV1 on FeedItem(
  after insert,
  after update,
  after delete,
  after undelete
) {
  OneGraphWebhookV1 job = new OneGraphWebhookV1(
    'FeedItem',
    Trigger.operationType
  );
  job.run();
}
