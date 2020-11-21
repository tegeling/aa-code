@isTest(SeeAllData=false)
public class FaithCampaignActionsTest {
  @isTest
  static void testCreateFaithCampaignWithFilters() {
    // Get Record Type Ids
    Id helferkreisRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Helferkreis')
      .getRecordTypeId();
    Id ehrenamtRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
      .get('Ehrenamtliche')
      .getRecordTypeId();
    Id faithRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
      .get('FAITH_Vermittlung')
      .getRecordTypeId();
    Id klientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Fluchtling')
      .getRecordTypeId();
    Id standortRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Standort')
      .getRecordTypeId();

    // create test records
    Account helferkreis = new Account(
      Name = 'Helferkeis',
      RecordTypeId = helferkreisRecordTypeId
    );
    insert helferkreis;
    Contact traumahelfer1 = new Contact(
      AccountId = helferkreis.Id,
      FirstName = 'Vorname1',
      LastName = 'Nachname1',
      RecordTypeId = ehrenamtRecordTypeId,
      Sprachen__c = 'Arabisch;Englisch;Bulgarisch',
      Status_FAITH__c = 'aktiv',
      TranslAid_Einsatz_Format__c = 'persönlich;telefonisch;schriftlich;per Video',
      Individueller_Einsatz_Standort__c = true,
      Einsatz_Standort__Latitude__s = 48.14294,
      Einsatz_Standort__Longitude__s = 11.541777,
      Einsatzradius_km__c = 100
    );
    insert traumahelfer1;

    Contact traumahelfer2 = new Contact(
      AccountId = helferkreis.Id,
      FirstName = 'FirstTraumahelfer2',
      LastName = 'LastTraumahelfer2',
      RecordTypeId = ehrenamtRecordTypeId,
      Sprachen__c = 'Bengali',
      Status_FAITH__c = 'interessiert'
    );
    insert traumahelfer2;

    Contact traumahelfer3 = new Contact(
      AccountId = helferkreis.Id,
      FirstName = 'VorSprach3',
      LastName = 'NachSprachmittler3',
      RecordTypeId = ehrenamtRecordTypeId,
      Sprachen__c = 'Arabisch;Englisch;Bulgarisch',
      Status_FAITH__c = 'aktiv',
      TranslAid_Einsatz_Format__c = 'persönlich;telefonisch;schriftlich;per Video',
      Individueller_Einsatz_Standort__c = true,
      Einsatz_Standort__Latitude__s = 48.14294,
      Einsatz_Standort__Longitude__s = 11.541777,
      Einsatzradius_km__c = 100
    );
    insert traumahelfer3;

    Account klient = new Account(
      FirstName = 'VornameKlient',
      LastName = 'NachnameKlient',
      RecordTypeId = klientRecordTypeId
    );
    insert klient;

    Account standort = new Account(
      Name = '001',
      RecordTypeId = standortRecordTypeId,
      BillingLatitude = 48.14294,
      BillingLongitude = 11.541777
    );
    insert standort;

    date myCloseDate = date.newInstance(2020, 1, 30);
    Opportunity vermittlung = new Opportunity(
      Name = 'Vermittlung',
      AccountId = klient.Id,
      RecordTypeId = faithRecordTypeId,
      StageName = 'Open',
      CloseDate = myCloseDate,
      Sprachen__c = 'Arabisch',
      Datenschutz__c = true,
      TranslAid_Einsatz_Format__c = 'persönlich',
      Termin_Standort__c = standort.Id
    );
    insert vermittlung;
    FaithCampaignRequest requestItem = new FaithCampaignRequest();
    requestItem.opportunityId = vermittlung.Id;
    requestItem.filterBySprachen = true;
    requestItem.filterByFormat = true;
    requestItem.filterByStandort = true;
    List<FaithCampaignRequest> request = new List<FaithCampaignRequest>();
    request.add(requestItem);
    Test.startTest();
    List<ID> campaigns = FaithCampaignActions.createFaithCampaignWithFilters(
      request
    );
    Test.stopTest();
    List<Campaign> campaignsResult = [SELECT id FROM Campaign];
    System.assertEquals(campaigns.size(), campaignsResult.size());
  }
}
