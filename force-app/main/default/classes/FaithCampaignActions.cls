public without sharing class FaithCampaignActions {
  @InvocableMethod(
    label='Create FAITH Campaign with Filters'
    description='Create a campaign for a FAITH Opportunity and apply filters.'
  )
  public static List<ID> createFaithCampaignWithFilters(
    List<FaithCampaignRequest> request
  ) {
    Id faithRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName()
      .get('FAITH_Campaign')
      .getRecordTypeId();
    String[] criteria = new List<String>{};
    String query = '';
    String whereClause = '';
    String orderByClause = ' ORDER BY Name';
    List<ID> campaigns = new List<ID>();
    List<CampaignMember> members = new List<CampaignMember>();
    List<Opportunity> opportunityList = new List<Opportunity>();
    List<Contact> traumahelfer = new List<Contact>();

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

    for (FaithCampaignRequest r : request) {
      Opportunity curOpportunity = [
        SELECT
          Name,
          Sprachen__c,
          OwnerId,
          TranslAid_Einsatz_Format__c,
          Termin_Standort__r.BillingLatitude,
          Termin_Standort__r.BillingLongitude
        FROM Opportunity
        WHERE Id = :r.opportunityId
      ];
      // create a new campaign
      Campaign camp = new Campaign(
        Name = 'FAITH Anfrage ' + curOpportunity.Name,
        IsActive = true,
        OwnerId = curOpportunity.OwnerId,
        RecordTypeId = faithRecordTypeId,
        StartDate = Date.today(),
        Status = 'In Progress',
        Type = 'FAITH Email'
      );
      insert camp;

      // link opportunity with campaign
      curOpportunity.CampaignId = camp.Id;
      campaigns.add(camp.Id);
      opportunityList.add(curOpportunity);

      // check filter and create dynamic query
      criteria.add('Status_FAITH__c IN (\'aktiv\',\'Multiplikator*in\')');

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
        formateFilter = '(TranslAid_Einsatz_Format__c = \'\' OR TranslAid_Einsatz_Format__c INCLUDES (';
        formateList.addAll(formateSet);
        integer count = 0;
        while (count < formateList.size()) {
          formateFilter += '\'' + formateList.get(count) + '\'';
          count++;
          if (count < formateList.size()) {
            formateFilter += ',';
          }
        }
        formateFilter += '))';
        criteria.add(formateFilter);
      }

      if (criteria.size() > 0) {
        whereClause = 'WHERE ' + String.join(criteria, ' AND ');
      }
      query =
        'SELECT ' +
        'Id, ' +
        'Name, ' +
        'Einsatz_Standort__c, ' +
        'Einsatzradius_km__c ' +
        'FROM Contact ' +
        whereClause +
        orderByClause;
      System.debug('#### query: ' + query);
      traumahelfer = Database.query(query);

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
          for (Contact currentContact : traumahelfer) {
            if (currentContact.Einsatzradius_km__c != null) {
              currentDistance = Location.getDistance(
                standortTermin,
                currentContact.Einsatz_Standort__c,
                'km'
              );
              if (currentDistance <= currentContact.Einsatzradius_km__c) {
                contactsWithinDistance.add(currentContact);
              }
            } else {
              contactsWithinDistance.add(currentContact);
            }
          }
          traumahelfer = contactsWithinDistance;
        }
      }

      // Add campaign members
      for (Contact c : traumahelfer) {
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
