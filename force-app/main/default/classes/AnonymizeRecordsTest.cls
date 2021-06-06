@isTest
private class AnonymizeRecordsTest {
  @testSetup
  static void setup() {
    // Create Anonym Records
    List<Anonym__c> testAnonym = new List<Anonym__c>();
    testAnonym.add(new Anonym__c(Name__c = 'Anonyme*r Blaues Ordensband'));
    testAnonym.add(new Anonym__c(Name__c = 'Anonyme*r Pilzeule'));
    testAnonym.add(
      new Anonym__c(Name__c = 'Anonyme*r Trockenrasen-Grasbüscheleule')
    );
    insert testAnonym;
  }

  @isTest
  static void testAnonymizePersonAccount() {
    // Get Record Type Ids
    Id klientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Fluchtling')
      .getRecordTypeId();
    // create test records
    Account klient = new Account(
      FirstName = 'Vorname',
      LastName = 'Nachname',
      PersonEmail = 'mymail@test.com',
      BillingCity = 'Berlin',
      ShippingCountry = 'Germany',
      PersonMailingStreet = 'Lindenstraße',
      PersonBirthdate = system.today(),
      RecordTypeId = klientRecordTypeId
    );
    insert klient;
    List<String> recordsAcc = new List<String>();
    recordsAcc.add(klient.Id);

    List<String> recordsCt = new List<String>();
    String contactId = [
      SELECT PersonContactId
      FROM Account
      WHERE Id = :klient.Id
    ]
    .PersonContactId;
    recordsCt.add(contactId);

    List<List<String>> records = new List<List<String>>();
    records.add(recordsAcc);
    records.add(recordsCt);

    // run test
    Test.startTest();
    AnonymizeRecords.anonymize(records);
    Test.stopTest();

    Account anonymizedAcc = [
      SELECT
        FirstName,
        LastName,
        PersonEmail,
        PersonBirthdate,
        BillingCity,
        ShippingCity
      FROM Account
      WHERE Id = :klient.Id
    ];

    System.assert(
      String.isBlank(anonymizedAcc.FirstName),
      'First Name is not null'
    );
    System.assert(
      anonymizedAcc.LastName.startsWith('Anonym'),
      'Last Name is not anonymized'
    );
    System.assert(
      String.isBlank(anonymizedAcc.PersonEmail),
      'Person Email is not null'
    );
    System.assertNotEquals(
      anonymizedAcc.PersonBirthdate,
      system.today(),
      'Birthdate is not randomized'
    );
    System.assert(
      String.isBlank(anonymizedAcc.BillingCity),
      'Billing City is not null'
    );
    System.assert(
      String.isBlank(anonymizedAcc.ShippingCity),
      'Shipping City is not null'
    );
  }

  @isTest
  static void testAnonymizeContact() {
    // create test records
    Contact c = new Contact(
      FirstName = 'Vorname',
      LastName = 'Nachname',
      Birthdate = system.today()
    );
    insert c;
    List<String> recordsCt = new List<String>();
    recordsCt.add(c.Id);

    List<List<String>> records = new List<List<String>>();
    records.add(recordsCt);

    // run test
    Test.startTest();
    AnonymizeRecords.anonymize(records);
    Test.stopTest();

    Contact anonymizedCt = [
      SELECT FirstName, LastName, Birthdate
      FROM Contact
      WHERE Id = :c.Id
    ];

    System.assert(
      String.isBlank(anonymizedCt.FirstName),
      'First Name is not null'
    );
    System.assert(
      anonymizedCt.LastName.startsWith('Anonym'),
      'Last Name is not anonymized'
    );
    System.assertNotEquals(
      anonymizedCt.Birthdate,
      system.today(),
      'Birthdate is not randomized'
    );
  }
}
