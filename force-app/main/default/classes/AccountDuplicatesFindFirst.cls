public without sharing class AccountDuplicatesFindFirst {
  @InvocableMethod(
    label='Retrieve first duplicate Account record'
    description='Returns first Account record based on duplicate rules.'
  )
  public static List<String> getFirst(
    List<DuplicatesHelper.AccountRequest> request
  ) {
    List<String> duplicateAccountList = new List<String>();
    for (DuplicatesHelper.AccountRequest r : request) {
      DuplicatesHelper helper = new DuplicatesHelper(r);
      List<String> matchedAccounts = helper.getMatchedAccounts();
      if (matchedAccounts.size() > 0) {
        duplicateAccountList.add(matchedAccounts.get(0));
      }
    }
    return duplicateAccountList;
  }
}
