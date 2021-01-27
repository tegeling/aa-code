public class TranslAid_ProjektActions {
  public static void statusUpdate(
    Map<Id, TranslAid_Projekt__c> oldProjekt,
    Map<Id, TranslAid_Projekt__c> newProjekt
  ) {
    List<TranslAid_Projekt_Event__e> events = new List<TranslAid_Projekt_Event__e>();
    for (TranslAid_Projekt__c newP : newProjekt.values()) {
      TranslAid_Projekt__c oldP = oldProjekt.get(newP.Id);
      if (oldP.Status__c != newP.Status__c) {
        TranslAid_Projekt_Event__e evt = new TranslAid_Projekt_Event__e();
        evt.TranslAid_Projekt_Id__c = newP.Id;
        evt.Action__c = newP.Status__c;
        events.add(evt);
      }
    }
    // Call method to publish events
    List<Database.SaveResult> results = EventBus.publish(events);

    // Inspect publishing result for each event
    for (Database.SaveResult sr : results) {
      if (sr.isSuccess()) {
        System.debug('Successfully published event.');
      } else {
        for (Database.Error err : sr.getErrors()) {
          System.debug(
            'Error returned: ' +
            err.getStatusCode() +
            ' - ' +
            err.getMessage()
          );
        }
      }
    }
  }
}
