trigger TranslAid_ProjektTrigger on TranslAid_Projekt__c(after update) {
  TranslAid_ProjektTriggerHandler handler = new TranslAid_ProjektTriggerHandler(
    Trigger.isExecuting,
    Trigger.size
  );

  if (Trigger.isUpdate) {
    if (Trigger.isAfter) {
      handler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
    }
  }
}
