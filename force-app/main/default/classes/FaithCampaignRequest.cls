public class FaithCampaignRequest {
  @InvocableVariable(
    label='Opportunity Id'
    description='FAITH Opportunity with Anfrage details'
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
}
