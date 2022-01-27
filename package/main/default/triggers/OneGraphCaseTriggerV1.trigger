trigger OneGraphCaseTriggerV1 on Case(
  after insert,
  after update,
  after delete,
  after undelete
) {
  OneGraphWebhookV1 job = new OneGraphWebhookV1('Case', Trigger.operationType);
  job.run();
}
