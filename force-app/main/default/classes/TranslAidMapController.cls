public with sharing class TranslAidMapController {
  @AuraEnabled(cacheable=true)
  public static List<Location> getLocations(List<Id> recordIds) {
    List<Opportunity> opps = [
      SELECT
        Id,
        Name,
        Termin_Standort__r.BillingLatitude,
        Termin_Standort__r.BillingLongitude
      FROM Opportunity
      WHERE Id IN :recordIds
      WITH SECURITY_ENFORCED
    ];
    List<Location> loc = new List<Location>();
    for (Opportunity o : opps) {
      GeoLocation geoInfo = new GeoLocation();
      geoInfo.Latitude = String.valueOf(o.Termin_Standort__r.BillingLatitude);
      geoInfo.Longitude = String.valueOf(o.Termin_Standort__r.BillingLongitude);
      Location locDetail = new Location();
      locDetail.value = o.Id;
      locDetail.icon = 'custom:custom61';
      locDetail.title = o.Name;
      locDetail.location = geoInfo;
      loc.add(locDetail);
    }
    return loc;
  }

  public class Location {
    @AuraEnabled
    public String value { get; set; }
    @AuraEnabled
    public String icon { get; set; }
    @AuraEnabled
    public String title { get; set; }
    @AuraEnabled
    public String description { get; set; }
    @AuraEnabled
    public GeoLocation location { get; set; }
  }

  public class GeoLocation {
    @AuraEnabled
    public String Latitude { get; set; }
    @AuraEnabled
    public String Longitude { get; set; }
  }
}
