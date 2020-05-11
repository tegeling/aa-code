@isTest(SeeAllData=false)
public class OpportunityTriggerTest {
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

    vermittlung.Fallnummer2__c = '1';
    vermittlung.Sprachen__c = 'Arabisch';
    vermittlung.Termin_Datum__c = myCloseDate;
    vermittlung.Uhrzeit__c = '10:00 Uhr';
    vermittlung.Termin_Dauer__c = '1 Stunde';
    vermittlung.Termin_Details__c = 'Details';
    vermittlung.Termin_Adresse__c = 'Adresse';
    Test.startTest();
    update vermittlung;
    Test.stopTest();
    Opportunity o = [
      SELECT id, Dolmetscher_Email__c
      FROM Opportunity
      WHERE Id = :vermittlung.Id
    ];
    System.assertEquals(
      'Fall: 1<br>Arabisch<br><b>am 30.01.2020 um 10:00 Uhr (1 Stunde)</b><br>Details<br>Strasse 1<br>12345 Stadt<br>',
      o.Dolmetscher_Email__c
    );
  }

  @isTest
  static void testCreateTranslAidCampaign() {
    // Get Record Type Ids
    Id helferkreisRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Helferkreis')
      .getRecordTypeId();
    Id ehrenamtRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
      .get('Ehrenamtliche')
      .getRecordTypeId();
    Id vermittlungRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
      .get('TranslAid_Vermittlung')
      .getRecordTypeId();
    Id klientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Fluchtling')
      .getRecordTypeId();

    // create test records
    Account helferkreis = new Account(
      Name = 'Helferkeis',
      RecordTypeId = helferkreisRecordTypeId
    );
    insert helferkreis;
    Contact sprachmittler1 = new Contact(
      AccountId = helferkreis.Id,
      FirstName = 'VornameSprachmittler1',
      LastName = 'NachnameSprachmittler1',
      RecordTypeId = ehrenamtRecordTypeId,
      Sprachen__c = 'Arabisch;Bulgarisch',
      Status_TranslAid__c = 'aktiv'
    );
    insert sprachmittler1;
    Contact sprachmittler2 = new Contact(
      AccountId = helferkreis.Id,
      FirstName = 'FirstSprachmittler2',
      LastName = 'LastSprachmittler2',
      RecordTypeId = ehrenamtRecordTypeId,
      Sprachen__c = 'Bengali',
      Status_TranslAid__c = 'kommt zur Einführung'
    );
    insert sprachmittler2;
    Account klient = new Account(
      FirstName = 'VornameKlient',
      LastName = 'NachnameKlient',
      RecordTypeId = klientRecordTypeId
    );
    insert klient;

    date myCloseDate = date.newInstance(2020, 1, 30);
    Opportunity vermittlung = new Opportunity(
      Name = 'Vermittlung',
      AccountId = klient.Id,
      RecordTypeId = vermittlungRecordTypeId,
      StageName = 'Open',
      CloseDate = myCloseDate,
      Sprachen__c = 'Arabisch',
      Datenschutz__c = true
    );
    insert vermittlung;
    List<Opportunity> opportunityList = new List<Opportunity>();
    opportunityList.add(vermittlung);
    Test.startTest();
    List<ID> campaigns = OpportunityActions.createTranslAidCampaign(
      opportunityList
    );
    Test.stopTest();
    List<Campaign> campaignsResult = [SELECT id FROM Campaign];
    System.assertEquals(campaigns.size(), campaignsResult.size());
  }
}