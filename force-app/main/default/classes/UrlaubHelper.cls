public with sharing class UrlaubHelper {
  public static void deleteUrlaubRecords(UrlaubRequest p) {
    // check date formats and if end is greater than start
    if (p.startDate > p.endDate) {
      return;
    }
    // remove existing record within interval
    List<Urlaub__c> removeInterval = [
      SELECT Id, Datum__c
      FROM Urlaub__c
      WHERE
        Datum__c >= :p.startDate
        AND Datum__c <= :p.endDate
        AND Contact__c = :p.contactId
      WITH SECURITY_ENFORCED
    ];
    delete removeInterval;
    return;
  }

  public static void createUrlaubRecords(UrlaubRequest p) {
    List<Urlaub__c> insertInterval = new List<Urlaub__c>();
    if (p.startDate > p.endDate) {
      return;
    }
    // remove existing record within interval
    List<Urlaub__c> removeInterval = [
      SELECT Id, Datum__c
      FROM Urlaub__c
      WHERE
        Datum__c >= :p.startDate
        AND Datum__c <= :p.endDate
        AND Contact__c = :p.ContactId
      WITH SECURITY_ENFORCED
    ];
    delete removeInterval;

    // add new record for interval
    Date currentDt = p.startDate;
    while (currentDt <= p.endDate) {
      Urlaub__c newUrlaub = new Urlaub__c(
        Contact__c = p.contactId,
        Datum__c = currentDt
      );
      insertInterval.add(newUrlaub);
      currentDt = currentDt.addDays(1);
    }
    insert insertInterval;
    return;
  }

  public class UrlaubRequest {
    @InvocableVariable(
      label='Contact Id'
      description='Record Id of Contact'
      required=true
    )
    public Id contactId;

    @InvocableVariable(
      label='Start Date'
      description='Date of PTO start'
      required=true
    )
    public date startDate;
    @InvocableVariable(
      label='End Date Body'
      description='Date of PTO end'
      required=true
    )
    public date endDate;
  }
}
