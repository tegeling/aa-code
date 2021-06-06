trigger J_C_Klient_innen_UpdateTrigger on J_C_Klient_innen_Update__c(
  after insert,
  after update
) {
  J_C_Klient_innen_UpdateTriggerHandler handler = new J_C_Klient_innen_UpdateTriggerHandler(
    Trigger.isExecuting,
    Trigger.size
  );

  if (Trigger.isInsert) {
    if (Trigger.isAfter) {
      handler.onAfterInsert(Trigger.New);
    }
  } else if (Trigger.isUpdate) {
    if (Trigger.isAfter) {
      handler.onAfterUpdate(
        Trigger.New,
        Trigger.Old,
        Trigger.NewMap,
        Trigger.OldMap
      );
    }
  }
}
