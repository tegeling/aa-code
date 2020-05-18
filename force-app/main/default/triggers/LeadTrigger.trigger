trigger LeadTrigger on Lead(before insert, before update) {
  LeadTriggerHandler handler = new LeadTriggerHandler(
    Trigger.isExecuting,
    Trigger.size
  );

  if (Trigger.isInsert) {
    if (Trigger.isBefore) {
      handler.onBeforeInsert(Trigger.New);
    }
  } else if (Trigger.isUpdate) {
    if (Trigger.isBefore) {
      handler.onBeforeUpdate(
        Trigger.New,
        Trigger.Old,
        Trigger.NewMap,
        Trigger.OldMap
      );
    }
  }
}
