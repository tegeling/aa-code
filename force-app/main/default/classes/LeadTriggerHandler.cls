public with sharing class LeadTriggerHandler {
  private boolean isExecuting = false;
  private integer batchSize = 0;

  public LeadTriggerHandler(boolean isExecuting, integer size) {
    isExecuting = isExecuting;
    batchSize = size;
  }

  public void onBeforeInsert(List<Lead> newLead) {
    LeadActions.translaidSetAktionstermine(newLead);
  }
  public void onBeforeUpdate(
    List<Lead> newLead,
    List<Lead> oldLead,
    Map<ID, Lead> newLeadMap,
    Map<ID, Lead> oldLeadMap
  ) {
    LeadActions.translaidSetAktionstermine(newLead);
  }
}