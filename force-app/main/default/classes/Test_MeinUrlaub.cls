@isTest(SeeAllData=false)
public with sharing class Test_MeinUrlaub {
  @isTest
  static void testV1DoGetAllFilter() {
    // Set up a test request
    RestRequest request = new RestRequest();
    RestResponse response = new RestResponse();
    // Set request properties
    request.requestUri = '/services/apexrest/v1/MeinUrlaub';
    request.httpMethod = 'GET';
    // Set other properties, such as parameters
    request.params.put('filter', 'all');
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

    // invoke test
    Test.startTest();
    System.runAs(userA) {
      MeinUrlaub.doGet();
    }
    Test.stopTest();
  }

  @isTest
  static void testV1DoGetTodayFilter() {
    // Set up a test request
    RestRequest request = new RestRequest();
    RestResponse response = new RestResponse();
    // Set request properties
    request.requestUri = '/services/apexrest/v1/MeinUrlaub';
    request.httpMethod = 'GET';
    // Set other properties, such as parameters
    request.params.put('filter', 'today');
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

    // invoke test
    Test.startTest();
    System.runAs(userA) {
      MeinUrlaub.doGet();
    }
    Test.stopTest();
  }

  @isTest
  static void testV1DoGetNoFilter() {
    // Set up a test request
    RestRequest request = new RestRequest();
    RestResponse response = new RestResponse();
    // Set request properties
    request.requestUri = '/services/apexrest/v1/MeinUrlaub';
    request.httpMethod = 'GET';
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

    // invoke test
    Test.startTest();
    System.runAs(userA) {
      MeinUrlaub.doGet();
    }
    Test.stopTest();
  }

  @isTest
  static void testV1DoPost() {
    // Set up a test request
    RestRequest request = new RestRequest();
    RestResponse response = new RestResponse();
    // Set request properties
    request.requestUri = '/services/apexrest/v1/MeinUrlaub';
    request.httpMethod = 'POST';
    // Set other properties, such as parameters
    request.requestBody = Blob.valueOf(
      '{"urlaub": [{"startDate" : "2020-01-01","endDate" : "2020-01-15"}]}'
    );
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

    // invoke test
    Test.startTest();
    List<MeinUrlaubParameter> meinUrlaubParams = new List<MeinUrlaubParameter>();
    MeinUrlaubParameter meinUrlaub1 = new MeinUrlaubParameter();
    meinUrlaub1.startDate = '2020-01-01';
    meinUrlaub1.endDate = '2020-01-15';
    meinUrlaubParams.add(meinUrlaub1);

    System.runAs(userA) {
      MeinUrlaub.doPost(meinUrlaubParams);
    }
    Test.stopTest();
    List<Urlaub__c> urlaub = [SELECT Id FROM Urlaub__c];
    System.assertEquals(urlaub.size(), 15);
  }

  @isTest
  static void testV1DoPostInvalidDate() {
    // Set up a test request
    RestRequest request = new RestRequest();
    RestResponse response = new RestResponse();
    // Set request properties
    request.requestUri = '/services/apexrest/v1/MeinUrlaub';
    request.httpMethod = 'POST';
    // Set other properties, such as parameters
    request.requestBody = Blob.valueOf(
      '{"urlaub": [{"startDate" : "2020-01-01","endDate" : "invalid"}]}'
    );
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

    // invoke test
    Test.startTest();
    List<MeinUrlaubParameter> meinUrlaubParams = new List<MeinUrlaubParameter>();
    MeinUrlaubParameter meinUrlaub1 = new MeinUrlaubParameter();
    meinUrlaub1.startDate = '2020-01-01';
    meinUrlaub1.endDate = 'invalid';
    meinUrlaubParams.add(meinUrlaub1);

    System.runAs(userA) {
      MeinUrlaub.doPost(meinUrlaubParams);
    }
    Test.stopTest();
  }

  @isTest
  static void testV1DoPostInvalidOrder() {
    // Set up a test request
    RestRequest request = new RestRequest();
    RestResponse response = new RestResponse();
    // Set request properties
    request.requestUri = '/services/apexrest/v1/MeinUrlaub';
    request.httpMethod = 'POST';
    // Set other properties, such as parameters
    request.requestBody = Blob.valueOf(
      '{"urlaub": [{"startDate" : "2020-01-15","endDate" : "2020-01-01"}]}'
    );
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

    // invoke test
    Test.startTest();
    List<MeinUrlaubParameter> meinUrlaubParams = new List<MeinUrlaubParameter>();
    MeinUrlaubParameter meinUrlaub1 = new MeinUrlaubParameter();
    meinUrlaub1.startDate = '2020-01-15';
    meinUrlaub1.endDate = '2020-01-01';
    meinUrlaubParams.add(meinUrlaub1);
    System.runAs(userA) {
      MeinUrlaub.doPost(meinUrlaubParams);
    }
    Test.stopTest();
  }

  @isTest
  static void testV1DoDelete() {
    // Set up a test request
    RestRequest request = new RestRequest();
    RestResponse response = new RestResponse();
    // Set request properties
    request.requestUri = '/services/apexrest/v1/MeinUrlaub';
    request.httpMethod = 'DELETE';
    // Set other properties, such as parameters
    request.params.put('startDate', '2020-01-01');
    request.params.put('endDate', '2020-01-15');
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

    // invoke test
    Test.startTest();
    System.runAs(userA) {
      MeinUrlaub.doDelete();
    }
    Test.stopTest();
    List<Urlaub__c> urlaub = [SELECT Id FROM Urlaub__c];
    System.assertEquals(urlaub.size(), 0);
  }

  @isTest
  static void testV1DoDeleteInvalidDate() {
    // Set up a test request
    RestRequest request = new RestRequest();
    RestResponse response = new RestResponse();
    // Set request properties
    request.requestUri = '/services/apexrest/v1/MeinUrlaub';
    request.httpMethod = 'DELETE';
    // Set other properties, such as parameters
    request.params.put('startDate', '2020-01-01');
    request.params.put('endDate', 'invalid');
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

    // invoke test
    Test.startTest();
    System.runAs(userA) {
      MeinUrlaub.doDelete();
    }
    Test.stopTest();
  }

  @isTest
  static void testV1DoDeleteInvalidOrder() {
    // Set up a test request
    RestRequest request = new RestRequest();
    RestResponse response = new RestResponse();
    // Set request properties
    request.requestUri = '/services/apexrest/v1/MeinUrlaub';
    request.httpMethod = 'DELETE';
    // Set other properties, such as parameters
    request.params.put('startDate', '2020-01-15');
    request.params.put('endDate', '2020-01-01');
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

    // invoke test
    Test.startTest();
    System.runAs(userA) {
      MeinUrlaub.doDelete();
    }
    Test.stopTest();
  }
}
