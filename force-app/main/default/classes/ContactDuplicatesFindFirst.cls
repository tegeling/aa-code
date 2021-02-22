public without sharing class ContactDuplicatesFindFirst {
  @InvocableMethod(
    label='Retrieve first duplicate Contact record'
    description='Returns first Contact record based on duplicate rules.'
  )
  public static List<String> getFirst(
    List<DuplicatesHelper.ContactRequest> request
  ) {
    List<String> duplicateContactList = new List<String>();
    for (DuplicatesHelper.ContactRequest r : request) {
      DuplicatesHelper helper = new DuplicatesHelper(r);
      List<String> matchedContacts = helper.getMatchedContacts();
      if (matchedContacts.size() > 0) {
        duplicateContactList.add(matchedContacts.get(0));
      }
    }
    return duplicateContactList;
  }
}
