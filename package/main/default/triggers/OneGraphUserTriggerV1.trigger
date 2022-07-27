trigger OneGraphUserTriggerV1 on User(
  after insert,
  after update,
  after delete,
  after undelete
) {
  OneGraphWebhookV1 job = new OneGraphWebhookV1(
    'User',
    Trigger.operationType
  );
  job.run();
}
