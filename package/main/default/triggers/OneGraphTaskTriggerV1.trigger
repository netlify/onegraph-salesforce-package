trigger OneGraphTaskTriggerV1 on Task(
  after insert,
  after update,
  after delete,
  after undelete
) {
  OneGraphWebhookV1 job = new OneGraphWebhookV1('Task', Trigger.operationType);
  job.run();
}
