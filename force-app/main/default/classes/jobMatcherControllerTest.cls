@isTest(SeeAllData=false)
public class jobMatcherControllerTest {
  @testSetup
  static void setup() {
    jobMatcherControllerTestDataFactory.createTestRecords();
  }

  @isTest
  static void getAllAccountOwners() {
    List<User> allAccountOwner = jobMatcherController.getAllAccountOwners();
    System.assertEquals(3, allAccountOwner.size());
  }

  @isTest
  static void getActiveAccountOwners() {
    List<User> activeAccountOwner = jobMatcherController.getActiveAccountOwners();
    System.assertEquals(1, activeAccountOwner.size());
  }

  @isTest
  static void getJobs() {
    //
    Id applicantRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Fluchtling')
      .getRecordTypeId();

    Id unternehmenRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Unternehmen')
      .getRecordTypeId();

    // select PersonAccount and Owners record id
    Account applicant = [
      SELECT Id
      FROM Account
      WHERE RecordTypeId = :applicantRecordTypeId
      LIMIT 1
    ];

    User userA = [SELECT Id FROM User WHERE Alias = 'userA'];
    User userB = [SELECT Id FROM User WHERE Alias = 'userB'];
    User userC = [SELECT Id FROM User WHERE Alias = 'userC'];

    String filters = '{"recordId":"' + applicant.Id + '",';
    filters += '"searchKey":"searchtext",';
    filters += '"createdDate":"2015-01-01T12:00:00",';
    filters += '"maxDistance":"100",';
    filters += '"categories":["Vollzeitstelle"],';
    filters +=
      '"owners":["' +
      userA.Id +
      '","' +
      userB.Id +
      '","' +
      userC.Id +
      '"]}';

    List<Job__c> jobs = jobMatcherController.getJobs(filters);
    System.assertEquals(2, jobs.size());
  }

  @isTest
  static void getAccounts() {
    Id unternehmenRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Unternehmen')
      .getRecordTypeId();
    Id applicantRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Fluchtling')
      .getRecordTypeId();

    // select Job and Owners record id
    Job__c job = [SELECT Id FROM Job__c WHERE Name = 'JobA1' LIMIT 1];

    User userA = [SELECT Id FROM User WHERE Alias = 'userA'];
    User userB = [SELECT Id FROM User WHERE Alias = 'userB'];
    User userC = [SELECT Id FROM User WHERE Alias = 'userC'];

    String filters = '{"recordId":"' + job.Id + '",';
    filters += '"searchKey":"searchtext",';
    filters += '"maxDistance":"100",';
    filters += '"categories":["Vollzeitstelle","Teilzeitstelle"],';
    filters +=
      '"owners":["' +
      userA.Id +
      '","' +
      userB.Id +
      '","' +
      userC.Id +
      '"]}';

    List<Account> accounts = jobMatcherController.getAccounts(filters);
    System.assertEquals(1, accounts.size());
  }

  @isTest
  static void getGoogleMapsURL() {
    Id unternehmenRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Unternehmen')
      .getRecordTypeId();
    Id applicantRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Fluchtling')
      .getRecordTypeId();

    // select PersonAccount and Job record id
    Account applicantA = [
      SELECT Id
      FROM Account
      WHERE RecordTypeId = :applicantRecordTypeId
      LIMIT 1
    ];
    Job__c jobA = [SELECT Id FROM Job__c WHERE Name = 'JobA1' LIMIT 1];

    String url = jobMatcherController.getGoogleMapsURL(jobA.Id, applicantA.Id);
    System.assertEquals(
      'https://www.google.com/maps/dir/?api=1&origin=&destination=&travelmode=transit',
      url
    );
  }
}
