public without sharing class AccountDuplicatesSize {
  @InvocableMethod(
    label='Retrieve number of duplicate Account records'
    description='Returns total number of Account records based on duplicate rules.'
  )
  public static List<Integer> getSize(
    List<DuplicatesHelper.AccountRequest> request
  ) {
    List<Integer> countAccountList = new List<Integer>();
    for (DuplicatesHelper.AccountRequest r : request) {
      DuplicatesHelper helper = new DuplicatesHelper(r);
      List<String> matchedAccounts = helper.getMatchedAccounts();
      countAccountList.add(matchedAccounts.size());
    }
    return countAccountList;
  }
}
