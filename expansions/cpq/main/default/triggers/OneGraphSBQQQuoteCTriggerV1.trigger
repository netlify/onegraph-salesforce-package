trigger OneGraphSBQQQuoteCTriggerV1 on SBQQ__Quote__c(
  after insert,
  after update,
  after delete,
  after undelete
) {
  OneGraphWebhookV1 job = new OneGraphWebhookV1(
    'SBQQ__Quote__c',
    Trigger.operationType
  );
  job.run();
}
