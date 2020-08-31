@isTest(SeeAllData=false)
public with sharing class Begleiter_inTriggerTest {
  @isTest
  static void testTrigger() {
    // Get Record Type Ids
    Id helferkreisRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Helferkreis')
      .getRecordTypeId();
    Id klientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Fluchtling')
      .getRecordTypeId();
    Id ehrenamtRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
      .get('Ehrenamtliche')
      .getRecordTypeId();
    Id begleitungRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
      .get('Begleitung')
      .getRecordTypeId();

    // create test records
    Account helferkreis = new Account(
      Name = 'Helferkeis',
      RecordTypeId = helferkreisRecordTypeId
    );
    insert helferkreis;
    Contact begleiter1 = new Contact(
      AccountId = helferkreis.Id,
      FirstName = 'VornameBegleiter1',
      LastName = 'NachnameBegleiter1',
      Email = 'begleiter1@email.com',
      MobilePhone = '+12345',
      Phone = '+12345',
      RecordTypeId = ehrenamtRecordTypeId
    );
    insert begleiter1;
    Contact begleiter2 = new Contact(
      AccountId = helferkreis.Id,
      FirstName = 'Begleiter2Vorname',
      LastName = 'Begleiter2Nachname',
      Email = 'email@Begleiter2.com',
      MobilePhone = '+12345',
      Phone = '+12345',
      RecordTypeId = ehrenamtRecordTypeId
    );
    insert begleiter2;
    Contact begleiter3 = new Contact(
      AccountId = helferkreis.Id,
      FirstName = 'DeleteVorname',
      LastName = 'DeleteNachname',
      Email = 'delete@email.com',
      MobilePhone = '+12345',
      Phone = '+12345',
      RecordTypeId = ehrenamtRecordTypeId
    );
    insert begleiter3;
    Account klient = new Account(
      FirstName = 'FirstKlient',
      LastName = 'LastKlient',
      RecordTypeId = klientRecordTypeId
    );
    insert klient;
    date myCloseDate = date.newInstance(2020, 1, 30);
    Opportunity begleitungOpportunity = new Opportunity(
      Name = 'Begleitung',
      AccountId = klient.Id,
      RecordTypeId = begleitungRecordTypeId,
      StageName = 'Open',
      CloseDate = myCloseDate,
      Datenschutz__c = true
    );
    insert begleitungOpportunity;
    Begleitung__c begleitung = new Begleitung__c(
      Opportunity__c = begleitungOpportunity.Id
    );
    insert begleitung;
    Begleiter_in__c b1 = new Begleiter_in__c(
      Begleitung__c = begleitung.Id,
      Ehrenamtliche_r__c = begleiter1.Id,
      Rolle__c = 'Sonstiges'
    );
    insert b1;
    Begleiter_in__c b2 = new Begleiter_in__c(
      Begleitung__c = begleitung.Id,
      Ehrenamtliche_r__c = begleiter2.Id,
      Rolle__c = 'Zweite*r Partner*in'
    );
    insert b2;
    Begleiter_in__c b3 = new Begleiter_in__c(
      Begleitung__c = begleitung.Id,
      Ehrenamtliche_r__c = begleiter3.Id,
      Rolle__c = 'Sonstiges'
    );
    insert b3;
    b1.Rolle__c = 'Erste*r Partner*in';
    update b1;
    delete b3;
    Begleitung__c result = [
      SELECT Email_Angaben_Begleiter_innen__c
      FROM Begleitung__c
      WHERE Id = :begleitung.Id
    ];
    String emailtext = 'Erste*r Partner*in: VornameBegleiter1 NachnameBegleiter1, begleiter1@email.com, +12345, +12345';
    emailtext += '\n';
    emailtext += 'Zweite*r Partner*in: Begleiter2Vorname Begleiter2Nachname, email@begleiter2.com, +12345, +12345';
    System.assertEquals(result.Email_Angaben_Begleiter_innen__c, emailtext);
  }
}
