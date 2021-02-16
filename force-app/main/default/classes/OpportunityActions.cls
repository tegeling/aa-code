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
        // flatten multiselect picklists and others as text
        o.Sprachen_As_Text__c = o.Sprachen__c;
        String TranslAidEinsatzFormat = o.TranslAid_Einsatz_Format__c;
        o.TranslAid_Einsatz_Format_As_Text__c = o.TranslAid_Einsatz_Format__c;
        o.CloseDate_As_Text__c = o.CloseDate.format();
        // set default email text
        o.Dolmetscher_Email__c = 'Fall: ' + o.Fallnummer2__c + '<br>';
        o.Dolmetscher_Email__c += 'Sprache: ' + o.Sprachen__c + '<br>';
        String beginn = '';
        if (o.Termin_Beginn__c != null) {
          // 10:00:00.000
          beginn += o.Termin_Beginn__c;
          beginn = beginn.left(beginn.lastIndexOf(':'));
          o.Termin_Beginn_As_Text__c = beginn;
        }
        if (o.CloseDate != null) {
          o.Dolmetscher_Email__c +=
            '<b>am ' +
            o.CloseDate.format() +
            ' um ' +
            beginn +
            ' Uhr (' +
            o.Termin_Dauer_min__c +
            ' Min)</b><br>';
        }
        o.Dolmetscher_Email__c += 'Details:<br>' + o.Termin_Details__c + '<br>';
        String adresse = '';
        List<Account> adressAccount = [
          SELECT BillingStreet, BillingPostalCode, BillingCity
          FROM Account
          WHERE Id = :o.Termin_Standort__c
        ];
        if (adressAccount.size() > 0) {
          if (adressAccount[0].BillingStreet != null) {
            adresse += adressAccount[0].BillingStreet + ', ';
          }
          if (adressAccount[0].BillingPostalCode != null) {
            adresse += adressAccount[0].BillingPostalCode + ' ';
          }
          if (adressAccount[0].BillingCity != null) {
            adresse += adressAccount[0].BillingCity;
          }
        }
        if (o.Geschlecht_Dolmetscherwunsch__c != null) {
          o.Dolmetscher_Email__c +=
            'Geschlecht Sprachmittler*in: ' +
            o.Geschlecht_Dolmetscherwunsch__c +
            '<br>';
        }
        o.Dolmetscher_Email__c += 'Einsatzort: ' + adresse + '<br>';
        o.Dolmetscher_Email__c += 'Einsatzformat: ' + TranslAidEinsatzFormat;
      }
    }
  }

  public static void faithSetEmailTemplate(List<Opportunity> newOpportunity) {
    // Set email template for FAITH contacts
    Id faithRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
      .get('FAITH_Vermittlung')
      .getRecordTypeId();
    for (Opportunity o : newOpportunity) {
      if (o.RecordTypeId == faithRecordTypeId) {
        // flatten multiselect picklists and others as text
        o.Sprachen_As_Text__c = o.Sprachen__c;
        o.TranslAid_Einsatz_Format_As_Text__c = o.TranslAid_Einsatz_Format__c;
        // set default email text
        String adresse = '';
        List<Account> adressAccount = [
          SELECT BillingStreet, BillingPostalCode, BillingCity
          FROM Account
          WHERE Id = :o.Termin_Standort__c
        ];
        if (adressAccount.size() > 0) {
          if (adressAccount[0].BillingStreet != null) {
            adresse += adressAccount[0].BillingStreet + ', ';
          }
          if (adressAccount[0].BillingPostalCode != null) {
            adresse += adressAccount[0].BillingPostalCode + ' ';
          }
          if (adressAccount[0].BillingCity != null) {
            adresse += adressAccount[0].BillingCity;
          }
        }
        Account klient = [
          SELECT Herkunftsland__c
          FROM Account
          WHERE Id = :o.AccountId
          LIMIT 1
        ];
        /*
        Einsatzort: Straße, Hausnr. PLZ
        Geschlecht:
        Herkunftsland/Ethnie:
        Sprache(n):
        */
        o.Dolmetscher_Email__c = 'Fall: ' + o.Fallnummer2__c + '<br>';
        o.Dolmetscher_Email__c += 'Einsatzort: ' + adresse + '<br>';
        if (o.Geschlecht_Dolmetscherwunsch__c != null) {
          o.Dolmetscher_Email__c +=
            'Geschlecht: ' +
            o.Geschlecht_Dolmetscherwunsch__c +
            '<br>';
        }
        if (klient.Herkunftsland__c != null) {
          o.Dolmetscher_Email__c +=
            'Herkunftsland/Ethnie: ' +
            klient.Herkunftsland__c +
            '<br>';
        }
        o.Dolmetscher_Email__c += 'Sprache(n): ' + o.Sprachen__c;
      }
    }
  }

  @InvocableMethod(
    label='Create TranslAid Campaign with Filters'
    description='Create a campaign for a TranslAid Opportunity and apply filters.'
  )
  public static List<ID> createTranslAidCampaignWithFilters(
    List<TranslAidCampaignRequest> request
  ) {
    Id translaidRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName()
      .get('TranslAid_Sprachmittler_in')
      .getRecordTypeId();
    String[] criteria = new List<String>{};
    String query = '';
    String whereClause = '';
    String orderByClause = ' ORDER BY Name';
    List<ID> campaigns = new List<ID>();
    List<CampaignMember> members = new List<CampaignMember>();
    List<Opportunity> opportunityList = new List<Opportunity>();
    List<Contact> sprachmittler = new List<Contact>();

    // define Format combinations to allow multiselect picklist matches
    List<String> formatPersoenlich = new List<String>{
      'persönlich;telefonisch;schriftlich;per Video',
      'persönlich;telefonisch;schriftlich',
      'persönlich;telefonisch;per Video',
      'persönlich;schriftlich;per Video',
      'persönlich;telefonisch',
      'persönlich;schriftlich',
      'persönlich;per Video',
      'persönlich'
    };
    List<String> formatTelefonisch = new List<String>{
      'persönlich;telefonisch;schriftlich;per Video',
      'persönlich;telefonisch;schriftlich',
      'persönlich;telefonisch;per Video',
      'telefonisch;schriftlich;per Video',
      'persönlich;telefonisch',
      'telefonisch;schriftlich',
      'telefonisch;per Video',
      'telefonisch'
    };
    List<String> formatSchriftlich = new List<String>{
      'persönlich;telefonisch;schriftlich;per Video',
      'persönlich;telefonisch;schriftlich',
      'persönlich;schriftlich;per Video',
      'telefonisch;schriftlich;per Video',
      'persönlich;schriftlich',
      'telefonisch;schriftlich',
      'schriftlich;per Video',
      'schriftlich'
    };
    List<String> formatPerVideo = new List<String>{
      'persönlich;telefonisch;schriftlich;per Video',
      'telefonisch;schriftlich;per Video',
      'persönlich;schriftlich;per Video',
      'persönlich;telefonisch;per Video',
      'persönlich;per Video',
      'telefonisch;per Video',
      'schriftlich;per Video',
      'per Video'
    };

    for (TranslAidCampaignRequest r : request) {
      Opportunity curOpportunity = [
        SELECT
          Name,
          CloseDate,
          Sprachen__c,
          TranslAid_Kategorie__c,
          OwnerId,
          TranslAid_Einsatz_Format__c,
          Termin_Verf_gbarkeit__c,
          Termin_Standort__r.BillingLatitude,
          Termin_Standort__r.BillingLongitude,
          Geschlecht_Dolmetscherwunsch__c
        FROM Opportunity
        WHERE Id = :r.opportunityId
      ];
      // create a new campaign
      Campaign camp = new Campaign(
        Name = 'TranslAid Sprachmittler ' + curOpportunity.Name,
        IsActive = true,
        OwnerId = curOpportunity.OwnerId,
        RecordTypeId = translaidRecordTypeId,
        StartDate = Date.today(),
        Status = 'In Progress',
        Type = 'TranslAid Push',
        Notification_Title__c = r.notificationTitle,
        Notification_Body__c = r.notificationBody
      );
      insert camp;

      // link opportunity with campaign
      curOpportunity.CampaignId = camp.Id;
      campaigns.add(camp.Id);
      opportunityList.add(curOpportunity);

      // check filter and create dynamic query
      criteria.add('Status_TranslAid__c = \'aktiv\'');

      // Sprachen Filter
      if ((curOpportunity.Sprachen__c != null) && (r.filterBySprachen)) {
        String sprachenFilter = '';
        List<String> sprachen = curOpportunity.Sprachen__c.split(';');
        integer count = 0;
        if (sprachen.size() > 0) {
          sprachenFilter = 'Sprachen__c INCLUDES (';
          while (count < sprachen.size()) {
            sprachenFilter += '\'' + sprachen.get(count) + '\'';
            count++;
            if (count < sprachen.size()) {
              sprachenFilter += ',';
            }
          }
          sprachenFilter += ')';
          criteria.add(sprachenFilter);
        }
      }

      // Kategorie Filter
      if (
        (curOpportunity.TranslAid_Kategorie__c != null) && (r.filterByKategorie)
      ) {
        String kategorienFilter = '';
        kategorienFilter = 'TranslAid_Kategorie__c INCLUDES (';
        kategorienFilter += '\'' + curOpportunity.TranslAid_Kategorie__c + '\'';
        kategorienFilter += ')';
        criteria.add(kategorienFilter);
      }

      // Gender Filter
      if (
        (curOpportunity.Geschlecht_Dolmetscherwunsch__c != null) &&
        (r.filterByGender)
      ) {
        String genderFilter = '';
        // check Contact Salutation
        if (curOpportunity.Geschlecht_Dolmetscherwunsch__c == 'Frau') {
          genderFilter = 'Salutation = \'Frau\'';
          criteria.add(genderFilter);
        } else if (curOpportunity.Geschlecht_Dolmetscherwunsch__c == 'Mann') {
          genderFilter = 'Salutation = \'Herr\'';
          criteria.add(genderFilter);
        }
      }

      // Format Filter
      if (
        (curOpportunity.TranslAid_Einsatz_Format__c != null) &&
        (r.filterByFormat)
      ) {
        String formateFilter = '';
        Set<String> formateSet = new Set<String>();
        List<String> formateList = new List<String>();
        Set<String> formate = new Set<String>(
          curOpportunity.TranslAid_Einsatz_Format__c.split(';')
        );
        // 'persönlich;telefonisch;schriftlich;per Video'
        if (formate.contains('persönlich')) {
          formateSet.addAll(formatPersoenlich);
        }
        if (formate.contains('telefonisch')) {
          formateSet.addAll(formatTelefonisch);
        }
        if (formate.contains('schriftlich')) {
          formateSet.addAll(formatSchriftlich);
        }
        if (formate.contains('per Video')) {
          formateSet.addAll(formatPerVideo);
        }
        formateFilter = 'TranslAid_Einsatz_Format__c INCLUDES (';
        formateList.addAll(formateSet);
        integer count = 0;
        while (count < formateList.size()) {
          formateFilter += '\'' + formateList.get(count) + '\'';
          count++;
          if (count < formateList.size()) {
            formateFilter += ',';
          }
        }
        formateFilter += ')';
        criteria.add(formateFilter);
      }

      // Verf_gbarkeit Filter
      if (
        (curOpportunity.Termin_Verf_gbarkeit__c != null) &&
        (r.filterByVerf_gbarkeit)
      ) {
        String verf_gbarkeitFilter = '';
        verf_gbarkeitFilter = 'Verf_gbarkeit__c INCLUDES (';
        verf_gbarkeitFilter +=
          '\'' +
          curOpportunity.Termin_Verf_gbarkeit__c +
          '\'';
        verf_gbarkeitFilter += ')';
        criteria.add(verf_gbarkeitFilter);
      }

      if (criteria.size() > 0) {
        whereClause = 'WHERE ' + String.join(criteria, ' AND ');
      }
      query =
        'SELECT ' +
        'Id, ' +
        'Name, ' +
        'Einsatz_Standort__Latitude__s, ' +
        'Einsatz_Standort__Longitude__s, ' +
        'Einsatzradius_km__c ' +
        'FROM Contact ' +
        whereClause +
        orderByClause;
      System.debug('#### query: ' + query);
      sprachmittler = Database.query(query);
      System.debug('#### sprachmittler.size(): ' + sprachmittler.size());

      // Urlaub Filter
      if (r.filterByUrlaub) {
        // query all Urlaub__c records in a Set of dates
        List<Contact> contactsWithoutUrlaub = new List<Contact>();
        Set<Id> urlaubSet = new Set<Id>();
        List<Urlaub__c> urlaubList = [
          SELECT Contact__c
          FROM Urlaub__c
          WHERE Datum__c = :curOpportunity.CloseDate
          WITH SECURITY_ENFORCED
        ];
        for (Urlaub__c currentUrlaub : urlaubList) {
          urlaubSet.add(currentUrlaub.Contact__c);
        }

        // iterate for each contact and check if id is a match with Urlaub
        for (Contact currentContact : sprachmittler) {
          if (!urlaubSet.contains(currentContact.Id)) {
            contactsWithoutUrlaub.add(currentContact);
          }
        }
        sprachmittler = contactsWithoutUrlaub;
      }

      // Standort Filter
      // check for contact if the distance is within the individual range
      if (r.filterByStandort) {
        // check if geodata is available
        if (
          (curOpportunity.Termin_Standort__r.BillingLatitude != null) &&
          (curOpportunity.Termin_Standort__r.BillingLongitude != null)
        ) {
          List<Contact> contactsWithinDistance = new List<Contact>();
          Location standortTermin = Location.newInstance(
            curOpportunity.Termin_Standort__r.BillingLatitude,
            curOpportunity.Termin_Standort__r.BillingLongitude
          );
          Double currentDistance = 0;
          // for each contact check the distance between their location and opportunity
          for (Contact currentContact : sprachmittler) {
            if (
              currentContact.Einsatzradius_km__c != null &&
              currentContact.Einsatz_Standort__Latitude__s != null &&
              currentContact.Einsatz_Standort__Longitude__s != null
            ) {
              Location standortContact = Location.newInstance(
                currentContact.Einsatz_Standort__Latitude__s,
                currentContact.Einsatz_Standort__Longitude__s
              );

              currentDistance = Location.getDistance(
                standortTermin,
                standortContact,
                'km'
              );
              if (currentDistance <= currentContact.Einsatzradius_km__c) {
                contactsWithinDistance.add(currentContact);
              }
            } else {
              contactsWithinDistance.add(currentContact);
            }
          }
          sprachmittler = contactsWithinDistance;
        }
      }

      // Add campaign members
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
