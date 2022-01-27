trigger OneGraphEventTriggerV1 on Event(
  after insert,
  after update,
  after delete,
  after undelete
) {
  OneGraphWebhookV1 job = new OneGraphWebhookV1(
    'Event',
    Trigger.operationType
  );
  job.run();
}
