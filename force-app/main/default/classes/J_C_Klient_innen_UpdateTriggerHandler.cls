public with sharing class J_C_Klient_innen_UpdateTriggerHandler {
  private boolean isExecuting = false;
  private integer batchSize = 0;

  public J_C_Klient_innen_UpdateTriggerHandler(
    boolean isExecuting,
    integer size
  ) {
    isExecuting = isExecuting;
    batchSize = size;
  }

  public void onAfterInsert(
    List<J_C_Klient_innen_Update__c> newJ_C_Klient_innen_Update
  ) {
    J_C_Klient_innen_UpdateActions.setChatterFollower(
      newJ_C_Klient_innen_Update
    );
  }

  public void onAfterUpdate(
    List<J_C_Klient_innen_Update__c> newJ_C_Klient_innen_Update,
    List<J_C_Klient_innen_Update__c> oldJ_C_Klient_innen_Update,
    Map<ID, J_C_Klient_innen_Update__c> newJ_C_Klient_innen_UpdateMap,
    Map<ID, J_C_Klient_innen_Update__c> oldJ_C_Klient_innen_UpdateMap
  ) {
    J_C_Klient_innen_UpdateActions.setChatterFollower(
      newJ_C_Klient_innen_Update
    );
  }
}
