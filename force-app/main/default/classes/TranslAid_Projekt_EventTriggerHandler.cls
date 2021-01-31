public class TranslAid_Projekt_EventTriggerHandler {
  private boolean isExecuting = false;
  private integer batchSize = 0;

  public TranslAid_Projekt_EventTriggerHandler(
    boolean isExecuting,
    integer size
  ) {
    isExecuting = isExecuting;
    batchSize = size;
  }

  public void onAfterInsert(Map<Id, TranslAid_Projekt_Event__e> newProjekt) {
    TranslAid_Projekt_EventActions.statusUpdate(newProjekt);
  }
}
