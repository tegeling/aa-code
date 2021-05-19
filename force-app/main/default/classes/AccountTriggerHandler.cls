public with sharing class AccountTriggerHandler {
  private boolean isExecuting = false;
  private integer batchSize = 0;

  public AccountTriggerHandler(boolean isExecuting, integer size) {
    isExecuting = isExecuting;
    batchSize = size;
  }

  public void onBeforeInsert(List<Account> newAccount) {
    AccountActions.setSprachniveau(newAccount);
  }

  public void onBeforeUpdate(
    List<Account> newAccount,
    List<Account> oldAccount,
    Map<ID, Account> newAccountMap,
    Map<ID, Account> oldAccountMap
  ) {
    AccountActions.setSprachniveau(newAccount);
  }
}
