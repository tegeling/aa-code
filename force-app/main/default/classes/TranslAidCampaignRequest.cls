public class TranslAidCampaignRequest {
  @InvocableVariable(
    label='Opportunity Id'
    description='TranslAid Opportunity with Anfrage details'
    required=true
  )
  public ID opportunityId;

  @InvocableVariable(
    label='Sprachfilter'
    description='True if Sprachen is used'
    required=true
  )
  public Boolean filterBySprachen;

  @InvocableVariable(
    label='Kategorienfilter'
    description='True if Kategorien is used'
    required=true
  )
  public Boolean filterByKategorie;

  @InvocableVariable(
    label='Formatfilter'
    description='True if Format is used'
    required=true
  )
  public Boolean filterByFormat;

  @InvocableVariable(
    label='Standortfilter'
    description='True if Standort is used'
    required=true
  )
  public Boolean filterByStandort;

  @InvocableVariable(
    label='Verf_gbarkeitfilter'
    description='True if Verf_gbarkeit is used'
    required=true
  )
  public Boolean filterByVerf_gbarkeit;

  @InvocableVariable(
    label='Urlaubfilter'
    description='True if Urlaub is used'
    required=true
  )
  public Boolean filterByUrlaub;

  @InvocableVariable(
    label='Push Notification Title'
    description='String to set notification title'
    required=true
  )
  public String notificationTitle;

  @InvocableVariable(
    label='Push Notification Body'
    description='String to set notification body'
    required=true
  )
  public String notificationBody;
}
