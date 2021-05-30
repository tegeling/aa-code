@isTest
public class jobMatcherControllerTestDataFactory {
  public static void createTestRecords() {
    // Get Record Type Ids
    Id unternehmenRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Unternehmen')
      .getRecordTypeId();
    Id applicantRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Fluchtling')
      .getRecordTypeId();

    // Create users A, B and C
    String uniqueUserNameA = 'standarduserA@testorg.com';
    String uniqueUserNameB = 'standarduserB@testorg.com';
    String uniqueUserNameC = 'standarduserC@testorg.com';

    Profile p = [SELECT Id FROM Profile WHERE Name = 'ArrivalAid Profile'];

    User userA = new User(
      Alias = 'userA',
      Email = 'standarduser@testorg.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Testing',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      ProfileId = p.Id,
      TimeZoneSidKey = 'Europe/Berlin',
      IsActive = true,
      UserName = uniqueUserNameA
    );
    insert userA;

    User userB = new User(
      Alias = 'userB',
      Email = 'standarduser@testorg.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Testing',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      ProfileId = p.Id,
      IsActive = true,
      TimeZoneSidKey = 'Europe/Berlin',
      UserName = uniqueUserNameB
    );
    insert userB;

    User userC = new User(
      Alias = 'userC',
      Email = 'standarduser@testorg.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Testing',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      ProfileId = p.Id,
      TimeZoneSidKey = 'Europe/Berlin',
      IsActive = false,
      UserName = uniqueUserNameC
    );
    insert userC;

    // create user A records
    System.runAs(userA) {
      // account with jobs
      Account accountA = new Account(
        Name = 'Unternehmen A ',
        RecordTypeId = unternehmenRecordTypeId,
        BillingLatitude = 48.09937,
        BillingLongitude = 11.53105
      );
      insert accountA;
      Job__c jobA1 = new Job__c(
        Name = 'JobA1',
        Account_Name__c = accountA.Id,
        Type__c = 'Vollzeitstelle',
        Description__c = 'searchtext'
      );
      Job__c jobA2 = new Job__c(
        Name = 'JobA2',
        Account_Name__c = accountA.Id,
        Type__c = 'Teilzeitstelle'
      );
      insert jobA1;
      insert jobA2;

      // PersonAccount
      Account applicantA = new Account(
        FirstName = 'ApplicantFirstName A - ' + DateTime.now().getTime(),
        LastName = 'ApplicantLastName A - ' + DateTime.now().getTime(),
        RecordTypeId = applicantRecordTypeId,
        Stellenvermittlung__pc = 'Vollzeitstelle',
        BillingLatitude = 48.09937,
        BillingLongitude = 11.53105
      );
      insert applicantA;
    }

    // create user B records
    System.runAs(userB) {
      // account with jobs
      Account accountB = new Account(
        Name = 'Account B',
        RecordTypeId = unternehmenRecordTypeId,
        BillingLatitude = 48.09937,
        BillingLongitude = 11.53105
      );
      insert accountB;
      Job__c jobB1 = new Job__c(
        Name = 'JobB1',
        Account_Name__c = accountB.Id,
        Type__c = 'Vollzeitstelle',
        Description__c = 'searchtext'
      );
      Job__c jobB2 = new Job__c(
        Name = 'JobB2',
        Account_Name__c = accountB.Id,
        Type__c = 'Teilzeitstelle'
      );
      insert jobB1;
      insert jobB2;
    }

    // create user C records
    // account with jobs
    Account accountC = new Account(
      Name = 'Gesellschaft C ',
      OwnerId = userC.Id,
      RecordTypeId = unternehmenRecordTypeId
    );
    insert accountC;
    Job__c jobC1 = new Job__c(
      Name = 'JobC1',
      Account_Name__c = accountC.Id,
      Type__c = 'Vollzeitstelle'
    );
    Job__c jobC2 = new Job__c(
      Name = 'JobC2',
      Account_Name__c = accountC.Id,
      Type__c = 'Teilzeitstelle'
    );
    insert jobC1;
    insert jobC2;
  }
}
