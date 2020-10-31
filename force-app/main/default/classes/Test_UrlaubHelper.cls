@isTest(SeeAllData=false)
public with sharing class Test_UrlaubHelper {
  @isTest
  static void testUrlaubDelete() {
    // Get Record Type Ids
    Id helferkreisRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Helferkreis')
      .getRecordTypeId();
    Id ehrenamtRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
      .get('Ehrenamtliche')
      .getRecordTypeId();

    // create test records
    Account helferkreis = new Account(
      Name = 'Helferkeis',
      RecordTypeId = helferkreisRecordTypeId
    );
    insert helferkreis;
    Contact dolmetscher = new Contact(
      AccountId = helferkreis.Id,
      FirstName = 'VornameDolmetscher',
      LastName = 'NachnameDometscher',
      RecordTypeId = ehrenamtRecordTypeId,
      TranslAid_Kategorie__c = 'allgemeine Beratung;juristische Beratung;medizinische Termine;sonstiges',
      TranslAid_Einsatz_Format__c = 'persönlich;telefonisch;schriftlich;per Video',
      Sprachen__c = 'Arabisch;Englisch',
      Individueller_Einsatz_Standort__c = true,
      Einsatz_Standort__Latitude__s = 47.884974,
      Einsatz_Standort__Longitude__s = 11.701570,
      Einsatzradius_km__c = 100
    );
    insert dolmetscher;

    List<UrlaubHelper.UrlaubRequest> p = new List<UrlaubHelper.UrlaubRequest>();
    UrlaubHelper.UrlaubRequest p1 = new UrlaubHelper.UrlaubRequest();
    p1.contactId = dolmetscher.Id;
    p1.startDate = Date.newInstance(2020, 1, 1);
    p1.endDate = Date.newInstance(2020, 1, 15);
    p.add(p1);
    List<Urlaub__c> insertInterval = new List<Urlaub__c>();
    // add new record for interval
    Date currentDt = p1.startDate;
    while (currentDt <= p1.endDate) {
      Urlaub__c newUrlaub = new Urlaub__c(
        Contact__c = p1.contactId,
        Datum__c = currentDt
      );
      insertInterval.add(newUrlaub);
      currentDt = currentDt.addDays(1);
    }
    insert insertInterval;

    // invoke test
    Test.startTest();
    UrlaubDeleteHelper.deleteUrlaub(p);
    Test.stopTest();
    List<Urlaub__c> urlaub = [SELECT Id FROM Urlaub__c];
    System.assertEquals(urlaub.size(), 0);
  }
  @isTest
  static void testUrlaubCreate() {
    // Get Record Type Ids
    Id helferkreisRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Helferkreis')
      .getRecordTypeId();
    Id ehrenamtRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
      .get('Ehrenamtliche')
      .getRecordTypeId();

    // create test records
    Account helferkreis = new Account(
      Name = 'Helferkeis',
      RecordTypeId = helferkreisRecordTypeId
    );
    insert helferkreis;
    Contact dolmetscher = new Contact(
      AccountId = helferkreis.Id,
      FirstName = 'VornameDolmetscher',
      LastName = 'NachnameDometscher',
      RecordTypeId = ehrenamtRecordTypeId,
      TranslAid_Kategorie__c = 'allgemeine Beratung;juristische Beratung;medizinische Termine;sonstiges',
      TranslAid_Einsatz_Format__c = 'persönlich;telefonisch;schriftlich;per Video',
      Sprachen__c = 'Arabisch;Englisch',
      Individueller_Einsatz_Standort__c = true,
      Einsatz_Standort__Latitude__s = 47.884974,
      Einsatz_Standort__Longitude__s = 11.701570,
      Einsatzradius_km__c = 100
    );
    insert dolmetscher;

    List<UrlaubHelper.UrlaubRequest> p = new List<UrlaubHelper.UrlaubRequest>();
    UrlaubHelper.UrlaubRequest p1 = new UrlaubHelper.UrlaubRequest();
    p1.contactId = dolmetscher.Id;
    p1.startDate = Date.newInstance(2020, 1, 1);
    p1.endDate = Date.newInstance(2020, 1, 15);
    p.add(p1);

    // invoke test
    Test.startTest();
    UrlaubCreateHelper.createUrlaub(p);
    Test.stopTest();
    List<Urlaub__c> urlaub = [SELECT Id FROM Urlaub__c];
    System.assertEquals(urlaub.size(), 15);
  }
}
