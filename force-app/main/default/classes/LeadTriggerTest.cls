@isTest(SeeAllData=false)
public with sharing class LeadTriggerTest {
  @isTest
  static void testTrigger() {
    // Get Record Type Ids
    Id traegerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Trager')
      .getRecordTypeId();
    Id ehrenamtRecordTypeId = Schema.SObjectType.Workshop__c.getRecordTypeInfosByDeveloperName()
      .get('Ehrenamt_Aktion')
      .getRecordTypeId();
    Id translAidDolmetscherRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName()
      .get('TranslAid_Dolmetscher')
      .getRecordTypeId();

    // create test records
    Account traeger = new Account(
      Name = 'Träger',
      RecordTypeId = traegerRecordTypeId
    );
    insert traeger;
    Lead sprachmittler = new Lead(
      LastName = 'Nachname',
      RecordTypeId = translAidDolmetscherRecordTypeId,
      Status = 'Open'
    );
    date startDatumFuture = Date.today().addDays(14);
    date startDatumPast = Date.today().addDays(-14);
    Time startUhrzeit = Time.newInstance(18, 0, 0, 0);

    Workshop__c translAidAktionValid = new Workshop__c(
      Tr_ger__c = traeger.Id,
      Name = 'Aktion',
      Workshop_Typ__c = 'TranslAid Einführung',
      RecordTypeId = ehrenamtRecordTypeId,
      ArrivalAid_Programm__c = 'TranslAid',
      Startdatum__c = startDatumFuture,
      Start_Uhrzeit__c = startUhrzeit
    );
    insert translAidAktionValid;
    Workshop__c translAidAktionPast = new Workshop__c(
      Tr_ger__c = traeger.Id,
      Name = 'translAidAktionPast',
      Workshop_Typ__c = 'TranslAid Einführung',
      RecordTypeId = ehrenamtRecordTypeId,
      ArrivalAid_Programm__c = 'TranslAid',
      Startdatum__c = startDatumPast,
      Start_Uhrzeit__c = startUhrzeit
    );
    insert translAidAktionPast;
    Workshop__c translAidAktionNoStartdate = new Workshop__c(
      Tr_ger__c = traeger.Id,
      Name = 'translAidAktionNoStartdate',
      Workshop_Typ__c = 'TranslAid Einführung',
      RecordTypeId = ehrenamtRecordTypeId,
      ArrivalAid_Programm__c = 'TranslAid'
    );
    insert translAidAktionNoStartdate;

    Test.startTest();
    insert sprachmittler;
    sprachmittler.FirstName = 'Vorname';
    update sprachmittler;
    Test.stopTest();
    Lead l = [
      SELECT id, Aktionstermine__c
      FROM Lead
      WHERE Id = :sprachmittler.Id
    ];
    System.assert(l.Aktionstermine__c.length() > 0);
  }
}
