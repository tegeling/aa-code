@isTest(SeeAllData=false)
public with sharing class TranslAidMapControllerTest {
  @isTest
  static void testGetLocations() {
    // Get Record Type Ids
    Id helferkreisRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Helferkreis')
      .getRecordTypeId();
    Id klientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Fluchtling')
      .getRecordTypeId();
    Id standortRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Standort')
      .getRecordTypeId();
    Id ehrenamtRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
      .get('Ehrenamtliche')
      .getRecordTypeId();
    Id vermittlungRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
      .get('TranslAid_Vermittlung')
      .getRecordTypeId();

    // create test records
    Account helferkreis = new Account(
      Name = 'Helferkeis',
      RecordTypeId = helferkreisRecordTypeId
    );
    insert helferkreis;
    Contact vermittler = new Contact(
      AccountId = helferkreis.Id,
      FirstName = 'VornameVermittler',
      LastName = 'NachnameVermittler',
      RecordTypeId = ehrenamtRecordTypeId
    );
    insert vermittler;
    Account klient = new Account(
      FirstName = 'FirstKlient',
      LastName = 'LastKlient',
      RecordTypeId = klientRecordTypeId
    );
    insert klient;
    Account standort = new Account(
      Name = '001',
      RecordTypeId = standortRecordTypeId
    );
    insert standort;
    date myCloseDate = date.newInstance(2020, 1, 30);
    Opportunity vermittlung = new Opportunity(
      Name = 'Vermittlung',
      AccountId = klient.Id,
      RecordTypeId = vermittlungRecordTypeId,
      StageName = 'Open',
      CloseDate = myCloseDate,
      Datenschutz__c = true,
      Termin_Standort__c = standort.Id
    );
    insert vermittlung;
    List<Id> recordIds = new List<Id>();
    recordIds.add(vermittlung.Id);
    List<TranslAidMapController.Location> locations = new List<TranslAidMapController.Location>();
    Test.startTest();
    locations = TranslAidMapController.getLocations(recordIds);
    Test.stopTest();
    System.assertEquals(locations.size(), 1);
  }
}