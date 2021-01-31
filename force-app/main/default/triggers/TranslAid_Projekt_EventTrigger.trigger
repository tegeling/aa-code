trigger TranslAid_Projekt_EventTrigger on TranslAid_Projekt_Event__e(
  after insert
) {
  TranslAid_Projekt_EventTriggerHandler handler = new TranslAid_Projekt_EventTriggerHandler(
    Trigger.isExecuting,
    Trigger.size
  );

  if (Trigger.isInsert) {
    if (Trigger.isAfter) {
      handler.onAfterInsert(Trigger.newMap);
    }
  }

}
