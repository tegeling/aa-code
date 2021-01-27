public class TranslAid_ProjektActions {
  public static void statusUpdate(
    Map<Id, TranslAid_Projekt__c> oldProjekt,
    Map<Id, TranslAid_Projekt__c> newProjekt
  ) {
    //
    Map<Id, Opportunity> updateOpportunity = new Map<Id, Opportunity>();
    for (TranslAid_Projekt__c newP : newProjekt.values()) {
      TranslAid_Projekt__c oldP = oldProjekt.get(newP.Id);
      System.debug('#### Old Status: ' + oldP.Status__c);
      System.debug('#### New Status: ' + newP.Status__c);
      if (oldP.Status__c != newP.Status__c) {
        Opportunity opp = [
          SELECT Id, StageName
          FROM Opportunity
          WHERE Id = :newP.Opportunity__c
        ];
        if (newP.Status__c == 'Einsatz erfolgreich beendet') {
          opp.StageName = 'Closed Won';
          updateOpportunity.put(opp.Id, opp);
        }
        System.debug('#### Opportunity: ' + opp.Id);
      }
    }
    update updateOpportunity.values();
  }
}
