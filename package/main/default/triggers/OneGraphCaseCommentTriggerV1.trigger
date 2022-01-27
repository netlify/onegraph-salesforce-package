trigger OneGraphCaseCommentTriggerV1 on CaseComment(
  after insert,
  after update,
  after delete,
  after undelete
) {
  OneGraphWebhookV1 job = new OneGraphWebhookV1(
    'CaseComment',
    Trigger.operationType
  );
  job.run();
}
