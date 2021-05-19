@isTest(SeeAllData=false)
public class TranslAid_ProjektTriggerTest {
  @isTest
  static void testTrigger() {
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
      RecordTypeId = klientRecordTypeId,
      Herkunftsland__pc = 'Afghanistan'
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
    Time myTime = Time.newInstance(10, 0, 0, 0);
    Opportunity vermittlung = new Opportunity(
      Name = 'Vermittlung',
      AccountId = klient.Id,
      RecordTypeId = vermittlungRecordTypeId,
      StageName = 'Open',
      CloseDate = myCloseDate,
      Termin_Beginn__c = myTime,
      Termin_Dauer_min__c = 60,
      Datenschutz__c = true,
      Termin_Standort__c = standort.Id,
      TranslAid_Einsatz_Format__c = 'persönlich',
      Termin_Adresse__c = 'Adresse',
      Termin_Details__c = 'Details',
      Sprachen__c = 'Arabisch',
      Fallnummer2__c = '1'
    );
    insert vermittlung;

    TranslAid_Projekt__c einsatz = new TranslAid_Projekt__c(
      Name = '1',
      Opportunity__c = vermittlung.Id,
      Status__c = 'Einsatz zugewiesen'
    );
    insert einsatz;

    Test.startTest();
    einsatz.Status__c = 'Einsatz erfolgreich beendet';
    update einsatz;
    einsatz.Status__c = 'Einsatz von Sprachmittler*in storniert';
    update einsatz;
    einsatz.Status__c = 'Einsatz von Klient*in storniert';
    update einsatz;
    Test.stopTest();
  }
}
