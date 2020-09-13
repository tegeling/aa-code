@isTest(SeeAllData=false)
public with sharing class Test_MeineAnfragen {
  @isTest
  static void testV1DoGetAllFilter() {
    // Set up a test request
    RestRequest request = new RestRequest();
    RestResponse response = new RestResponse();
    // Set request properties
    request.requestUri = '/services/apexrest/v1/MeineAnfragen';
    request.httpMethod = 'GET';
    // Set other properties, such as parameters
    request.params.put('filter', 'All');
    // Finally, assign the request to RestContext if used
    RestContext.request = request;
    RestContext.response = response;

    // Get Record Type Ids
    Id helferkreisRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Helferkreis')
      .getRecordTypeId();
    Id traegerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Trager')
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
    Contact dolmetscher = new Contact(
      AccountId = helferkreis.Id,
      FirstName = 'VornameDolmetscher',
      LastName = 'NachnameDometscher',
      RecordTypeId = ehrenamtRecordTypeId,
      TranslAid_Kategorie__c = 'allgemeine Beratung;juristische Beratung;medizinische Termine;sonstiges',
      TranslAid_Einsatz_Format__c = 'persönlich;telefonisch;schriftlich;per Video',
      Sprachen__c = 'Arabisch;Englisch',
      Verf_gbarkeit__c = 'Do vormittags (8-12);Do nachmittags (12-18)',
      Individueller_Einsatz_Standort__c = true,
      Einsatz_Standort__Latitude__s = 47.884974,
      Einsatz_Standort__Longitude__s = 11.701570,
      Einsatzradius_km__c = 100
    );
    insert dolmetscher;
    Date urlaub1Datum = date.newInstance(2020, 1, 30);
    Date urlaub2Datum = date.newInstance(2020, 1, 31);
    Urlaub__c urlaub1 = new Urlaub__c(
      Contact__c = dolmetscher.Id,
      Datum__c = urlaub1Datum
    );
    insert urlaub1;
    Urlaub__c urlaub2 = new Urlaub__c(
      Contact__c = dolmetscher.Id,
      Datum__c = urlaub2Datum
    );
    insert urlaub2;
    String uniqueUserName = 'dolmetscher@community.com';
    Profile p = [
      SELECT Id
      FROM Profile
      WHERE Name = 'TranslAid Community User'
    ];
    User userA = new User(
      Alias = 'userA',
      Email = 'dolmetscher@community.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Testing',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      ProfileId = p.Id,
      TimeZoneSidKey = 'Europe/Berlin',
      IsActive = true,
      UserName = uniqueUserName,
      ContactId = dolmetscher.Id
    );
    insert userA;

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
      RecordTypeId = standortRecordTypeId,
      BillingStreet = 'Strasse 1',
      BillingPostalCode = '12345',
      BillingCity = 'Stadt'
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

    // invoke test
    Test.startTest();
    System.runAs(userA) {
      MeineAnfragen.doGet();
    }
    Test.stopTest();
  }
  @isTest
  static void testV1DoGetWithException() {
    // Set up a test request
    RestRequest request = new RestRequest();
    RestResponse response = new RestResponse();
    // Set request properties
    request.requestUri = '/services/apexrest/v1/MeineAnfragen';
    request.httpMethod = 'GET';
    // Finally, assign the request to RestContext if used
    RestContext.request = request;
    RestContext.response = response;
    // invoke test
    Test.startTest();
    MeineAnfragen.doGet();
    Test.stopTest();
  }
}
