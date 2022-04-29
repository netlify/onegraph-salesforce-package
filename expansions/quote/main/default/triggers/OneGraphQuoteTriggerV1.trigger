trigger OneGraphQuoteTriggerV1 on Quote(
  after insert,
  after update,
  after delete,
  after undelete
) {
  OneGraphWebhookV1 job = new OneGraphWebhookV1('Quote', Trigger.operationType);
  job.run();
}
