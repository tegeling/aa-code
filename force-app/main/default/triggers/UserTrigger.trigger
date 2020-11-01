trigger UserTrigger on User(after insert, after update) {
  UserTriggerHandler handler = new UserTriggerHandler(
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
  }
}
