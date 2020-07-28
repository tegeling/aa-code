trigger Begleiter_inTrigger on Begleiter_in__c(
  after insert,
  after update,
  after delete
) {
  Begleiter_inTriggerHandler handler = new Begleiter_inTriggerHandler(
    Trigger.isExecuting,
    Trigger.size
  );

  if (Trigger.isInsert) {
    if (Trigger.isAfter) {
      handler.onAfterInsert(Trigger.new);
    }
  } else if (Trigger.isUpdate) {
    if (Trigger.isAfter) {
      handler.onAfterUpdate(Trigger.new, Trigger.old);
    }
  } else if (Trigger.isDelete) {
    if (Trigger.isAfter) {
      handler.onAfterDelete(Trigger.old);
    }
  }
}
