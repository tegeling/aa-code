public with sharing class UserTriggerHandler {
  private boolean isExecuting = false;
  private integer batchSize = 0;

  public UserTriggerHandler(boolean isExecuting, integer size) {
    isExecuting = isExecuting;
    batchSize = size;
  }
  public void onAfterInsert(List<User> newUser) {
    UserActions.setUserOnContact(newUser);
  }

  public void onAfterUpdate(List<User> newUser, List<User> oldUser) {
    UserActions.unsetUserOnContact(newUser);
  }
}
