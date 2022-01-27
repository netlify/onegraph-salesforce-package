trigger OneGraphAccountTriggerV1 on Account(
  after insert,
  after update,
  after delete,
  after undelete
) {
  OneGraphWebhookV1 job = new OneGraphWebhookV1(
    'Account',
    Trigger.operationType
  );
  job.run();
}
