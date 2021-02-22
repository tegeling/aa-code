@isTest(SeeAllData=false)
public inherited sharing class Test_DuplicatesHelper {
  @isTest
  static void testContactDuplicatesMatch() {
    // Get Record Type Ids
    Id helferkreisRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Helferkreis')
      .getRecordTypeId();
    Id allgemeinerKontaktRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
      .get('Allgemeiner_Kontakt')
      .getRecordTypeId();

    // create test records
    Account helferkreis = new Account(
      Name = 'Helferkeis',
      RecordTypeId = helferkreisRecordTypeId
    );
    insert helferkreis;
    Contact vermittlerA = new Contact(
      AccountId = helferkreis.Id,
      Salutation = 'Frau',
      FirstName = 'VornameVermittlerA',
      LastName = 'NachnameVermittlerA',
      RecordTypeId = allgemeinerKontaktRecordTypeId,
      Email = 'NachnameVermittlerA@helferkreis.de',
      Group_Email__c = false
    );
    insert vermittlerA;

    Contact vermittlerGroup = new Contact(
      AccountId = helferkreis.Id,
      Salutation = 'Frau',
      FirstName = 'VornameVermittlerGroup',
      LastName = 'NachnameVermittlerGroup',
      RecordTypeId = allgemeinerKontaktRecordTypeId,
      Email = 'kontakt@helferkreis.de',
      Group_Email__c = true
    );
    insert vermittlerGroup;

    // setup request parameter
    List<DuplicatesHelper.ContactRequest> requestWithName = new List<DuplicatesHelper.ContactRequest>();
    List<DuplicatesHelper.ContactRequest> requestWithId = new List<DuplicatesHelper.ContactRequest>();
    DuplicatesHelper.ContactRequest rWithName = new DuplicatesHelper.ContactRequest();
    rWithName.accountName = 'Helferorganisation';
    rWithName.contactRecordType = 'Allgemeiner_Kontakt';
    rWithName.firstName = 'VornameVermittlerA';
    rWithName.lastName = 'NachnameVermittlerA';
    rWithName.email = 'NachnameVermittlerA@helferkreis.de';
    rWithName.isGroupEmail = false;
    requestWithName.add(rWithName);

    DuplicatesHelper.ContactRequest rWithId = new DuplicatesHelper.ContactRequest();
    rWithId.accountId = helferkreis.Id;
    rWithId.contactRecordType = 'Allgemeiner_Kontakt';
    rWithId.firstName = 'VornameVermittlerA';
    rWithId.lastName = 'NachnameVermittlerA';
    rWithId.email = 'NachnameVermittlerA@helferkreis.de';
    rWithId.isGroupEmail = false;
    requestWithId.add(rWithId);

    // invoke test
    Test.startTest();
    List<String> resultFindFirstWithName = ContactDuplicatesFindFirst.getFirst(
      requestWithName
    );
    List<Integer> resultSizeWithName = ContactDuplicatesSize.getSize(
      requestWithName
    );
    List<String> resultFindFirstWithId = ContactDuplicatesFindFirst.getFirst(
      requestWithId
    );
    List<Integer> resultSizeWithId = ContactDuplicatesSize.getSize(
      requestWithId
    );
    Test.stopTest();
    System.assertEquals(
      resultFindFirstWithName.size(),
      1,
      'Expected a matched duplicate in resultFindFirstWithName.'
    );
    System.assertEquals(
      resultSizeWithName.size(),
      1,
      'Expected matched duplicate size of 1 in resultSizeWithName'
    );
    System.assertEquals(
      resultFindFirstWithId.size(),
      1,
      'Expected a matched duplicate in resultFindFirstWithId.'
    );
    System.assertEquals(
      resultSizeWithId.size(),
      1,
      'Expected matched duplicate size of 1 in resultSizeWithId'
    );
  }

  @isTest
  static void testAccountDuplicates() {
    // Get Record Type Ids
    Id helferkreisRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Helferkreis')
      .getRecordTypeId();
    Id allgemeinerKontaktRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
      .get('Allgemeiner_Kontakt')
      .getRecordTypeId();

    // create test records
    Account helferkreis = new Account(
      Name = 'Helferkeis',
      RecordTypeId = helferkreisRecordTypeId
    );
    insert helferkreis;
    Contact vermittlerA = new Contact(
      AccountId = helferkreis.Id,
      Salutation = 'Frau',
      FirstName = 'VornameVermittlerA',
      LastName = 'NachnameVermittlerA',
      RecordTypeId = allgemeinerKontaktRecordTypeId,
      Email = 'NachnameVermittlerA@helferkreis.de',
      Group_Email__c = false
    );
    insert vermittlerA;

    Account hilforganisation = new Account(
      Name = 'Hilfsorganisation',
      RecordTypeId = helferkreisRecordTypeId
    );
    insert hilforganisation;

    Contact vermittlerGroup = new Contact(
      AccountId = hilforganisation.Id,
      Salutation = 'Frau',
      FirstName = 'VornameVermittlerGroup',
      LastName = 'NachnameVermittlerGroup',
      RecordTypeId = allgemeinerKontaktRecordTypeId,
      Email = 'kontakt@helferkreis.de',
      Group_Email__c = true
    );
    insert vermittlerGroup;

    // setup request parameter
    List<DuplicatesHelper.AccountRequest> request = new List<DuplicatesHelper.AccountRequest>();
    DuplicatesHelper.AccountRequest r = new DuplicatesHelper.AccountRequest();
    r.accountName = 'Helferkeis';
    r.accountRecordType = 'Helferkreis';
    request.add(r);

    // invoke test
    Test.startTest();
    List<String> resultFindFirst = AccountDuplicatesFindFirst.getFirst(request);
    List<Integer> resultSize = AccountDuplicatesSize.getSize(request);
    Test.stopTest();
    System.assertEquals(
      resultFindFirst.size(),
      1,
      'Expected a matched duplicate in resultFindFirst.'
    );
    System.assertEquals(
      resultSize.size(),
      1,
      'Expected matched duplicate size of 1 in resultSize'
    );
  }
}
