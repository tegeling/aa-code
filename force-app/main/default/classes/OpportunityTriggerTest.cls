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
    Id faithRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
      .get('FAITH_Vermittlung')
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
      Herkunftsland__c = 'Afghanistan'
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
      Termin_Standort__c = standort.Id
    );
    insert vermittlung;

    Opportunity faith = new Opportunity(
      Name = 'Faith',
      AccountId = klient.Id,
      RecordTypeId = faithRecordTypeId,
      StageName = 'Open',
      CloseDate = myCloseDate,
      Datenschutz__c = true,
      Termin_Standort__c = standort.Id,
      Geschlecht_Dolmetscherwunsch__c = 'Egal'
    );
    insert faith;

    vermittlung.CloseDate = myCloseDate;
    vermittlung.Fallnummer2__c = '1';
    vermittlung.Sprachen__c = 'Arabisch';
    vermittlung.Termin_Beginn__c = Time.newInstance(11, 0, 0, 0);
    vermittlung.Termin_Dauer_min__c = 90;
    vermittlung.Termin_Details__c = 'Details';
    vermittlung.Termin_Adresse__c = 'Adresse';
    faith.Fallnummer2__c = '2';
    faith.Sprachen__c = 'Arabisch';
    Test.startTest();
    update vermittlung;
    update faith;
    Test.stopTest();
    Opportunity o1 = [
      SELECT id, Dolmetscher_Email__c
      FROM Opportunity
      WHERE Id = :vermittlung.Id
    ];
    Opportunity o2 = [
      SELECT id, Dolmetscher_Email__c
      FROM Opportunity
      WHERE Id = :faith.Id
    ];
    System.assertEquals(
      'Fall: 1<br>Arabisch<br><b>am 30.01.2020 um 11:00 Uhr (90 Min)</b><br>Details<br>Strasse 1<br>12345 Stadt<br>',
      o1.Dolmetscher_Email__c
    );
    System.assertEquals(
      'Fall: 2<br>Einsatzort: Strasse 1, 12345 Stadt<br>Geschlecht: Egal<br>Herkunftsland/Ethnie: Afghanistan<br>Sprache(n): Arabisch',
      o2.Dolmetscher_Email__c
    );
  }

  @isTest
  static void testCreateTranslAidCampaignWithFilters() {
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
    Id standortRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Standort')
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
      Sprachen__c = 'Arabisch;Englisch;Bulgarisch',
      Status_TranslAid__c = 'aktiv',
      Verf_gbarkeit__c = 'Do vormittags (bis 12 Uhr);Do nachmittags (12 bis 18 Uhr);Do abends (ab 18 Uhr)',
      TranslAid_Kategorie__c = 'Amtstermine;sonstiges;medizinische Termine',
      TranslAid_Einsatz_Format__c = 'persönlich;telefonisch;schriftlich;per Video',
      Individueller_Einsatz_Standort__c = true,
      Einsatz_Standort__Latitude__s = 48.14294,
      Einsatz_Standort__Longitude__s = 11.541777,
      Einsatzradius_km__c = 100
    );
    insert sprachmittler1;

    Urlaub__c urlaub1 = new Urlaub__c(
      Contact__c = sprachmittler1.Id,
      Datum__c = date.newInstance(2020, 1, 1)
    );
    insert urlaub1;
    Urlaub__c urlaub2 = new Urlaub__c(
      Contact__c = sprachmittler1.Id,
      Datum__c = date.newInstance(2020, 1, 2)
    );
    insert urlaub2;

    Contact sprachmittler2 = new Contact(
      AccountId = helferkreis.Id,
      FirstName = 'FirstSprachmittler2',
      LastName = 'LastSprachmittler2',
      RecordTypeId = ehrenamtRecordTypeId,
      Sprachen__c = 'Bengali',
      Status_TranslAid__c = 'kommt zur Einführung'
    );
    insert sprachmittler2;

    Contact sprachmittler3 = new Contact(
      AccountId = helferkreis.Id,
      FirstName = 'VorSprach3',
      LastName = 'NachSprachmittler3',
      RecordTypeId = ehrenamtRecordTypeId,
      Sprachen__c = 'Arabisch;Englisch;Bulgarisch',
      Status_TranslAid__c = 'aktiv',
      Verf_gbarkeit__c = 'Do vormittags (bis 12 Uhr);Do nachmittags (12 bis 18 Uhr);Do abends (ab 18 Uhr)',
      TranslAid_Kategorie__c = 'Amtstermine;sonstiges;medizinische Termine',
      TranslAid_Einsatz_Format__c = 'persönlich;telefonisch;schriftlich;per Video',
      Einsatzradius_km__c = 100
    );
    insert sprachmittler3;

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
      RecordTypeId = vermittlungRecordTypeId,
      StageName = 'Open',
      CloseDate = myCloseDate,
      Termin_Datum__c = myCloseDate,
      Sprachen__c = 'Arabisch',
      Datenschutz__c = true,
      TranslAid_Kategorie__c = 'Amtstermine',
      TranslAid_Einsatz_Format__c = 'persönlich;telefonisch;schriftlich;per Video',
      Termin_Standort__c = standort.Id
    );
    insert vermittlung;
    TranslAidCampaignRequest requestItem = new TranslAidCampaignRequest();
    requestItem.opportunityId = vermittlung.Id;
    requestItem.notificationTitle = 'Title';
    requestItem.notificationBody = 'Body';
    requestItem.filterBySprachen = true;
    requestItem.filterByKategorie = true;
    requestItem.filterByFormat = true;
    requestItem.filterByVerf_gbarkeit = true;
    requestItem.filterByStandort = true;
    requestItem.filterByUrlaub = true;
    List<TranslAidCampaignRequest> request = new List<TranslAidCampaignRequest>();
    request.add(requestItem);
    Test.startTest();
    List<ID> campaigns = OpportunityActions.createTranslAidCampaignWithFilters(
      request
    );
    Test.stopTest();
    List<Campaign> campaignsResult = [SELECT id FROM Campaign];
    System.assertEquals(campaigns.size(), campaignsResult.size());
  }
}
