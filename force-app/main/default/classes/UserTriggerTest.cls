@isTest(SeeAllData=false)
public with sharing class UserTriggerTest {
  @isTest
  static void testTrigger() {
    // Get Record Type Ids
    Id helferkreisRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Helferkreis')
      .getRecordTypeId();
    Id ehrenamtRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
      .get('Ehrenamtliche')
      .getRecordTypeId();
    Profile translaidCommunityProfile = [
      SELECT Id
      FROM Profile
      WHERE name = 'TranslAid Community User'
    ];
    // create test records
    Account helferkreis = new Account(
      Name = 'Helferkeis',
      RecordTypeId = helferkreisRecordTypeId
    );
    insert helferkreis;
    Contact mycontact = new Contact(
      AccountId = helferkreis.Id,
      FirstName = 'VornameBegleiter1',
      LastName = 'NachnameBegleiter1',
      Email = 'begleiter1@email.com',
      MobilePhone = '+12345',
      Phone = '+12345',
      RecordTypeId = ehrenamtRecordTypeId
    );
    insert mycontact;

    User u = new User();
    u.Username = mycontact.email;
    u.lastName = 'Test';
    u.Alias = 'testu';
    u.ProfileId = translaidCommunityProfile.Id;
    u.CommunityNickname = 'testu';
    u.Email = mycontact.email;
    u.contactid = mycontact.id;
    u.languagelocalekey = 'en_US';
    u.localesidkey = 'en_US';
    u.timezonesidkey = 'America/Los_Angeles';
    u.emailencodingkey = 'UTF-8';

    // Test User Insert
    insert u;
    //Id userid = Site.createExternalUser(u, helferkreis.Id);
    List<Contact> communityuserid = [
      SELECT Community_User__c
      FROM Contact
      WHERE Id = :mycontact.Id
    ];
    System.assertEquals(
      u.Id,
      communityuserid[0].Community_User__c,
      'User Id does not match with Contact detail.'
    );

    // Test User Update
    List<Id> updateContactsIds = new List<Id>();
    updateContactsIds.add(mycontact.Id);
    Test.startTest();
    updateUser(u.Id);
    UserActions.updateContacts(updateContactsIds);
    Test.stopTest();
    communityuserid = [
      SELECT Community_User__c
      FROM Contact
      WHERE Id = :mycontact.Id
    ];
    System.assertEquals(
      null,
      communityuserid[0].Community_User__c,
      'Contact detail not updated.'
    );
  }

  @future
  private static void updateUser(Id userid) {
    List<User> updateUsers = new List<User>();
    List<User> selectUsers = [SELECT Id, IsActive FROM User WHERE Id = :userid];
    for (User u : selectUsers) {
      u.IsActive = false;
      updateUsers.add(u);
    }
    update updateUsers;
  }
}
