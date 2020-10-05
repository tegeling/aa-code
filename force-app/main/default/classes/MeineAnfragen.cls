@RestResource(urlMapping='/v1/MeineAnfragen/*')
global with sharing class MeineAnfragen {
  @HttpGet
  global static void doGet() {
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String filterRaw = req.params.get('filter');
    String[] criteria = new List<String>{};
    String query = '';
    String whereClause = '';
    String orderByClause = ' ORDER BY Name';
    List<TranslAid_Anfrage__c> result = new List<TransLaid_Anfrage__c>();
    Boolean filterByAll = false;
    Boolean filterBySprachen = false;
    Boolean filterByKategorie = false;
    Boolean filterByFormat = false;
    Boolean filterByStandort = false;
    Boolean filterByZugewiesen = false;
    Boolean filterByVerf_gbarkeit = false;
    Boolean filterByUrlaub = false;
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

    // check filters
    try {
      List<String> filter = filterRaw.split(',');
      filterByAll = filter.contains('All') || filter.contains('all');
      filterBySprachen = filter.contains('Sprachen__c');
      filterByKategorie = filter.contains('TranslAid_Kategorie__c');
      filterByFormat = filter.contains('TranslAid_Einsatz_Format__c');
      filterByStandort = filter.contains('Termin_Standort__c');
      filterByZugewiesen = filter.contains('Zugewiesen__c');
      filterByUrlaub = filter.contains('Urlaub__c');
      filterByVerf_gbarkeit = filter.contains('Termin_Verf_gbarkeit__c');
    } catch (Exception ex) {
      res.statusCode = 400;
      MeineAnfragenError[] errs = new List<MeineAnfragenError>{
        new MeineAnfragenError(
          'BAD_REQUEST',
          'Param: filter is missing (like \'?filter=All\', or specific field API names)'
        )
      };
      res.responseBody = Blob.valueOf(JSON.serialize(errs));
      return;
    }
    // get contact and filter
    String userId = UserInfo.getUserId();
    User u = [
      SELECT ContactId
      FROM User
      WHERE Id = :userId
      WITH SECURITY_ENFORCED
    ];

    Contact c = [
      SELECT
        TranslAid_Kategorie__c,
        TranslAid_Einsatz_Format__c,
        Sprachen__c,
        Individueller_Einsatz_Standort__c,
        Einsatz_Standort__Latitude__s,
        Einsatz_Standort__Longitude__s,
        Einsatzradius_km__c,
        Verf_gbarkeit__c
      FROM Contact
      WHERE Id = :u.ContactId
      WITH SECURITY_ENFORCED
    ];

    // Sprachen Filter
    if ((c.Sprachen__c != null) && (filterByAll || filterBySprachen)) {
      String sprachenFilter = '';
      List<String> sprachen = c.Sprachen__c.split(';');
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
      (c.TranslAid_Kategorie__c != null) && (filterByAll || filterByKategorie)
    ) {
      String kategorienFilter = '';
      List<String> kategorien = c.TranslAid_Kategorie__c.split(';');
      integer count = 0;
      if (kategorien.size() > 0) {
        kategorienFilter = 'TranslAid_Kategorie__c IN (';
        while (count < kategorien.size()) {
          kategorienFilter += '\'' + kategorien.get(count) + '\'';
          count++;
          if (count < kategorien.size()) {
            kategorienFilter += ',';
          }
        }
        kategorienFilter += ')';
        criteria.add(kategorienFilter);
      }
    }
    // Format Filter
    if (
      (c.TranslAid_Einsatz_Format__c != null) && (filterByAll || filterByFormat)
    ) {
      String formateFilter = '';
      Set<String> formateSet = new Set<String>();
      List<String> formateList = new List<String>();
      Set<String> formate = new Set<String>(
        c.TranslAid_Einsatz_Format__c.split(';')
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

    // Verf_gbarkeit Filter Filter
    if (
      (c.Verf_gbarkeit__c != null) && (filterByAll || filterByVerf_gbarkeit)
    ) {
      String verf_gbarkeitFilter = '';
      List<String> verf_ugbarkeit = c.Verf_gbarkeit__c.split(';');
      integer count = 0;
      if (verf_ugbarkeit.size() > 0) {
        verf_gbarkeitFilter = 'Termin_Verf_gbarkeit__c IN (';
        while (count < verf_ugbarkeit.size()) {
          verf_gbarkeitFilter += '\'' + verf_ugbarkeit.get(count) + '\'';
          count++;
          if (count < verf_ugbarkeit.size()) {
            verf_gbarkeitFilter += ',';
          }
        }
        verf_gbarkeitFilter += ')';
        criteria.add(verf_gbarkeitFilter);
      }
    }

    // Standort Filter
    // WHERE+DISTANCE(Termin_Standort__c,+GEOLOCATION(48.14294,11.541777),'km')<50

    if (filterByAll || filterByStandort) {
      // check if geodata is available
      if (
        (c.Einsatz_Standort__Latitude__s != null) &&
        (c.Einsatz_Standort__Longitude__s != null) &&
        (c.Einsatzradius_km__c != null)
      ) {
        String standortFilter = '(DISTANCE(Termin_Standort__c, GEOLOCATION(';
        standortFilter +=
          c.Einsatz_Standort__Latitude__s +
          ',' +
          c.Einsatz_Standort__Longitude__s +
          '), \'km\')<' +
          c.Einsatzradius_km__c;
        standortFilter += ' OR Termin_Standort__latitude__s = null)';
        criteria.add(standortFilter);
      }
    }

    // Zugewiesen Filter
    if (filterByAll || filterByZugewiesen) {
      criteria.add('Zugewiesen__c = false');
    }

    if (criteria.size() > 0) {
      whereClause = 'WHERE ' + String.join(criteria, ' AND ');
    }

    query =
      'SELECT ' +
      'Id, ' +
      'Name, ' +
      'CreatedDate, ' +
      'LastModifiedDate, ' +
      'Sprachen__c, ' +
      'Sprachmittler_in__c, ' +
      'Termin_Standort__Latitude__s, ' +
      'Termin_Standort__Longitude__s, ' +
      'Termin_Details__c, ' +
      'TranslAid_Kategorie__c, ' +
      'TranslAid_Einsatz_Format__c, ' +
      'Zugewiesen__c, ' +
      'Meine_TranslAid_Anfrage__c, ' +
      'Termin_Adresse__c, ' +
      'Termin_Datum__c, ' +
      'Termin_Dauer_min__c, ' +
      'Termin_Beginn__c, ' +
      'Termin_Verf_gbarkeit__c ' +
      'FROM TranslAid_Anfrage__c ' +
      whereClause +
      orderByClause;
    System.debug('#### query: ' + query);
    result = Database.query(query);

    // Urlaub Filter
    if (filterByAll || filterByUrlaub) {
      // query all Urlaub__c records in a Set of dates
      List<TranslAid_Anfrage__c> resultWithoutUrlaub = new List<TransLaid_Anfrage__c>();
      Set<Date> urlaubSet = new Set<Date>();
      List<Urlaub__c> urlaubList = [
        SELECT Datum__c
        FROM Urlaub__c
        WHERE Contact__c = :u.ContactId
        WITH SECURITY_ENFORCED
      ];
      for (Urlaub__c currentUrlaub : urlaubList) {
        urlaubSet.add(currentUrlaub.Datum__c);
      }

      // iterate for each Anfrage and check if date is a match with Urlaub
      for (TranslAid_Anfrage__c currentAnfrage : result) {
        if (!urlaubSet.contains(currentAnfrage.Termin_Datum__c)) {
          resultWithoutUrlaub.add(currentAnfrage);
        }
      }
      res.statusCode = 200;
      res.headers.put('Content-Type', 'application/json');
      res.responseBody = Blob.valueOf(JSON.serialize(resultWithoutUrlaub));
    } else {
      res.statusCode = 200;
      res.headers.put('Content-Type', 'application/json');
      res.responseBody = Blob.valueOf(JSON.serialize(result));
    }
  }
}
