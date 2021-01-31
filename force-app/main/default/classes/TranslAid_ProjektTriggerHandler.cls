public class TranslAid_ProjektTriggerHandler {
  private boolean isExecuting = false;
  private integer batchSize = 0;

  public TranslAid_ProjektTriggerHandler(boolean isExecuting, integer size) {
    isExecuting = isExecuting;
    batchSize = size;
  }

  public void onAfterUpdate(
    Map<Id, TranslAid_Projekt__c> newProjekt,
    Map<Id, TranslAid_Projekt__c> oldProjekt
  ) {
    TranslAid_ProjektActions.statusUpdate(oldProjekt, newProjekt);
  }
}
