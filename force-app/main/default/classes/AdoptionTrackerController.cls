public class AdoptionTrackerController {
  @AuraEnabled
  @future
  public static void publishEvent(String feature, String action) {
    Adoption_Event__e event = new Adoption_Event__e(
      Feature__c = feature,
      Action__c = action
    );

    Database.SaveResult result = EventBus.publish(event);

    if (!result.isSuccess()) {
      for (Database.Error error : result.getErrors()) {
        System.debug(
          'Error returned: ' +
          error.getStatusCode() +
          ' - ' +
          error.getMessage()
        );
      }
    }
  }
}
