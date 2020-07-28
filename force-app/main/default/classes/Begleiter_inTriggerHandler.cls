public with sharing class Begleiter_inTriggerHandler {
  private boolean isExecuting = false;
  private integer batchSize = 0;

  public Begleiter_inTriggerHandler(boolean isExecuting, integer size) {
    isExecuting = isExecuting;
    batchSize = size;
  }

  public void onAfterInsert(List<Begleiter_in__c> newBegleiter_in) {
    Begleiter_inActions.setBegleiter_in(newBegleiter_in);
  }

  public void onAfterUpdate(
    List<Begleiter_in__c> newBegleiter_in,
    List<Begleiter_in__c> oldBegleiter_in
  ) {
    Begleiter_inActions.setBegleiter_in(newBegleiter_in);
  }

  public void onAfterDelete(List<Begleiter_in__c> oldBegleiter_in) {
    Begleiter_inActions.setBegleiter_in(oldBegleiter_in);
  }
}
