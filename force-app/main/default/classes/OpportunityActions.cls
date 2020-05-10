public without sharing class OpportunityActions {
  public static void translaidSetEmailTemplate(
    List<Opportunity> newOpportunity
  ) {
    // Set email template for Dolmetscher
    Id translaidRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
      .get('TranslAid_Vermittlung')
      .getRecordTypeId();
    for (Opportunity o : newOpportunity) {
      if (o.RecordTypeId == translaidRecordTypeId) {
        o.Dolmetscher_Email__c = 'Fall: ' + o.Fallnummer2__c + '<br>';
        o.Dolmetscher_Email__c += o.Sprachen__c + '<br>';
        if (o.Termin_Datum__c != null) {
          o.Dolmetscher_Email__c +=
            '<b>am ' +
            o.Termin_Datum__c.format() +
            ' um ' +
            o.Uhrzeit__c +
            ' (' +
            o.Termin_Dauer__c +
            ')</b><br>';
        } else {
          o.Dolmetscher_Email__c +=
            '<b>um ' +
            o.Uhrzeit__c +
            ' (' +
            o.Termin_Dauer__c +
            ')</b><br>';
        }
        o.Dolmetscher_Email__c += o.Termin_Details__c + '<br>';
        String adresse = '';
        List<Account> adressAccount = [
          SELECT BillingStreet, BillingPostalCode, BillingCity
          FROM Account
          WHERE Id = :o.Termin_Standort__c
        ];
        if (adressAccount.size() > 0) {
          if (adressAccount[0].BillingStreet != null) {
            adresse += adressAccount[0].BillingStreet + '<br>';
          }
          if (adressAccount[0].BillingPostalCode != null) {
            adresse += adressAccount[0].BillingPostalCode + ' ';
          }
          if (adressAccount[0].BillingCity != null) {
            adresse += adressAccount[0].BillingCity + '<br>';
          }
        }
        o.Dolmetscher_Email__c += adresse;
      }
    }
  }

  @InvocableMethod(
    label='Create TranslAid Campaign'
    description='Create an email campaign for a TranslAid Opportunity.'
  )
  public static List<ID> createTranslAidCampaign(
    List<Opportunity> opportunityList
  ) {
    Id translaidRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName()
      .get('TranslAid_Sprachmittler_in')
      .getRecordTypeId();
    List<ID> campaigns = new List<ID>();
    List<CampaignMember> members = new List<CampaignMember>();
    for (Opportunity o : opportunityList) {
      Opportunity curOpportunity = [
        SELECT Name, Sprachen__c, OwnerId
        FROM Opportunity
        WHERE Id = :o.Id
      ];
      // create a new campaign
      Campaign camp = new Campaign(
        Name = 'Email ' + curOpportunity.Name,
        IsActive = true,
        OwnerId = curOpportunity.OwnerId,
        RecordTypeId = translaidRecordTypeId,
        StartDate = Date.today(),
        Status = 'In Progress',
        Type = 'TranslAid Email'
      );
      insert camp;

      // link opportunity with campaign
      o.CampaignId = camp.Id;
      campaigns.add(camp.Id);

      // select Contacts with Sprachen
      List<Contact> sprachmittler = [
        SELECT Id, Name
        FROM Contact
        WHERE
          Status_TranslAid__c = 'aktiv'
          AND Sprachen__c INCLUDES (:curOpportunity.Sprachen__c)
      ];
      for (Contact c : sprachmittler) {
        // add campaign member
        CampaignMember m = new CampaignMember(
          CampaignId = camp.Id,
          ContactId = c.Id,
          Status = 'Sent'
        );
        members.add(m);
      }
    }
    insert members;
    update opportunityList;
    return campaigns;
  }
}