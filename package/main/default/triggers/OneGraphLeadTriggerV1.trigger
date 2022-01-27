trigger OneGraphLeadTriggerV1 on Lead(
  after insert,
  after update,
  after delete,
  after undelete
) {
  OneGraphWebhookV1 job = new OneGraphWebhookV1('Lead', Trigger.operationType);
  job.run();
}
