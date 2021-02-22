public without sharing class ContactDuplicatesSize {
  @InvocableMethod(
    label='Retrieve number of duplicate Contact records'
    description='Returns total number of Contact records based on duplicate rules.'
  )
  public static List<Integer> getSize(
    List<DuplicatesHelper.ContactRequest> request
  ) {
    List<Integer> countContactList = new List<Integer>();
    for (DuplicatesHelper.ContactRequest r : request) {
      DuplicatesHelper helper = new DuplicatesHelper(r);
      List<String> matchedContacts = helper.getMatchedContacts();
      countContactList.add(matchedContacts.size());
    }
    return countContactList;
  }
}
