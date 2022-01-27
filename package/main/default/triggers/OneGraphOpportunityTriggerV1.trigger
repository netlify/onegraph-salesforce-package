trigger OneGraphOpportunityTriggerV1 on Opportunity(
  after insert,
  after update,
  after delete,
  after undelete
) {
  OneGraphWebhookV1 job = new OneGraphWebhookV1(
    'Opportunity',
    Trigger.operationType
  );
  job.run();
}
