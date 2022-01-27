trigger OneGraphContactTriggerV1 on Contact(
  after insert,
  after update,
  after delete,
  after undelete
) {
  OneGraphWebhookV1 job = new OneGraphWebhookV1(
    'Contact',
    Trigger.operationType
  );
  job.run();
}
