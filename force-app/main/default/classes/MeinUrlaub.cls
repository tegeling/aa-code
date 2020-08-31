@RestResource(urlMapping='/v1/MeinUrlaub/*')
global with sharing class MeinUrlaub {
  @HttpGet
  global static void doGet() {
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String filterRaw = req.params.get('filter');
    List<Urlaub__c> result = new List<Urlaub__c>();
    Boolean filterByAll = false;
    Boolean filterByToday = false;

    // check filters
    try {
      List<String> filter = filterRaw.split(',');
      filterByAll = filter.contains('All') || filter.contains('all');
      filterByToday = filter.contains('Today') || filter.contains('today');
    } catch (Exception ex) {
      res.statusCode = 400;
      MeineAnfragenError[] errs = new List<MeineAnfragenError>{
        new MeineAnfragenError(
          'BAD_REQUEST',
          'Param: filter is missing (like \'?filter=all\' or \'?filter=today\')'
        )
      };
      res.responseBody = Blob.valueOf(JSON.serialize(errs));
      return;
    }

    // get contact
    String userId = UserInfo.getUserId();
    User u = [
      SELECT ContactId
      FROM User
      WHERE Id = :userId
      WITH SECURITY_ENFORCED
    ];

    // query all Urlaub or only Urlaub greater today
    if (filterByAll) {
      result = [
        SELECT Id, Name, CreatedDate, LastModifiedDate, Datum__c
        FROM Urlaub__c
        WHERE Contact__c = :u.ContactId
        WITH SECURITY_ENFORCED
        ORDER BY Datum__c
      ];
    } else {
      result = [
        SELECT Id, Name, CreatedDate, LastModifiedDate, Datum__c
        FROM Urlaub__c
        WHERE Contact__c = :u.ContactId AND Datum__c >= TODAY
        WITH SECURITY_ENFORCED
        ORDER BY Datum__c
      ];
    }
    res.statusCode = 200;
    res.headers.put('Content-Type', 'application/json');
    res.responseBody = Blob.valueOf(JSON.serialize(result));
  }

  @HttpPost
  global static void doPost(String startDate, String endDate) {
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    Date startDt;
    Date endDt;
    // get contact
    String userId = UserInfo.getUserId();
    User u = [
      SELECT ContactId
      FROM User
      WHERE Id = :userId
      WITH SECURITY_ENFORCED
    ];

    // check date formats and if end is greater than start
    try {
      startDt = Date.valueOf(startDate);
      endDt = Date.valueOf(endDate);
    } catch (Exception ex) {
      res.statusCode = 400;
      MeineAnfragenError[] errs = new List<MeineAnfragenError>{
        new MeineAnfragenError(
          'BAD_REQUEST',
          'Values or format for startDate or endDate are invalid.'
        )
      };
      res.responseBody = Blob.valueOf(JSON.serializePretty(errs));
      return;
    }
    if (startDt > endDt) {
      res.statusCode = 400;
      MeineAnfragenError[] errs = new List<MeineAnfragenError>{
        new MeineAnfragenError(
          'INVALID_DATES',
          'startDate and endDate are in wrong order.'
        )
      };
      res.responseBody = Blob.valueOf(JSON.serializePretty(errs));
      return;
    }
    // remove existing record within interval
    List<Urlaub__c> removeInterval = [
      SELECT Id, Datum__c
      FROM Urlaub__c
      WHERE Datum__c >= :startDt AND Datum__c <= :endDt
      WITH SECURITY_ENFORCED
    ];
    delete removeInterval;

    // add new record for interval
    Date currentDt = startdt;
    List<Urlaub__c> insertInterval = new List<Urlaub__c>();
    while (currentDt <= endDt) {
      Urlaub__c urlaub = new Urlaub__c(
        Contact__c = u.ContactId,
        Datum__c = currentDt
      );
      insertInterval.add(urlaub);
      currentDt = currentDt.addDays(1);
    }
    insert insertInterval;
    res.responseBody = Blob.valueOf(JSON.serializePretty(insertInterval));
    return;
  }

  @HttpDelete
  global static void doDelete() {
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String startDateRaw = req.params.get('startDate');
    String endDateRaw = req.params.get('endDate');

    Date startDt;
    Date endDt;

    // check date formats and if end is greater than start
    try {
      startDt = Date.valueOf(startDateRaw);
      endDt = Date.valueOf(endDateRaw);
    } catch (Exception ex) {
      res.statusCode = 400;
      MeineAnfragenError[] errs = new List<MeineAnfragenError>{
        new MeineAnfragenError(
          'BAD_REQUEST',
          'Values or format for startDate or endDate are invalid.'
        )
      };
      res.responseBody = Blob.valueOf(JSON.serializePretty(errs));
      return;
    }
    if (startDt > endDt) {
      res.statusCode = 400;
      MeineAnfragenError[] errs = new List<MeineAnfragenError>{
        new MeineAnfragenError(
          'INVALID_DATES',
          'startDate and endDate are in wrong order.'
        )
      };
      res.responseBody = Blob.valueOf(JSON.serializePretty(errs));
      return;
    }

    // remove existing record within interval
    List<Urlaub__c> removeInterval = [
      SELECT Id, Datum__c
      FROM Urlaub__c
      WHERE Datum__c >= :startDt AND Datum__c <= :endDt
      WITH SECURITY_ENFORCED
    ];
    delete removeInterval;
    res.responseBody = Blob.valueOf(JSON.serializePretty(removeInterval));
    return;
  }
}
