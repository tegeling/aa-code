public with sharing class UserActions {
  public static void setUserOnContact(List<User> newUser) {
    List<Contact> updateContacts = new List<Contact>();
    for (User u : newUser) {
      if (u.ContactId != null) {
        Contact c = [
          SELECT Id, Community_User__c
          FROM Contact
          WHERE Id = :u.ContactId
        ];
        c.Community_User__c = u.Id;
        updateContacts.add(c);
      }
    }
    update updateContacts;
  }

  public static void unsetUserOnContact(List<User> newUser) {
    List<Id> updateContactIds = new List<Id>();
    for (User u : newUser) {
      if (u.ContactId != null && !u.IsActive) {
        Contact c = [
          SELECT Id, Community_User__c
          FROM Contact
          WHERE Id = :u.ContactId
        ];
        updateContactIds.add(c.Id);
      }
    }
    if (!System.isFuture() && !System.isBatch()) {
      updateContacts(updateContactIds);
    }
  }

  @future
  public static void updateContacts(List<Id> updateContactIds) {
    List<Contact> updateContacts = new List<Contact>();
    List<Contact> selectContacts = [
      SELECT Id, Community_User__c
      FROM Contact
      WHERE Id IN :updateContactIds
    ];
    for (Contact c : selectContacts) {
      c.Community_User__c = null;
      updateContacts.add(c);
    }
    update updateContacts;
  }
}
