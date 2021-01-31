public class TranslAid_Projekt_EventActions {
  public static void statusUpdate(
    Map<Id, TranslAid_Projekt_Event__e> newProjekt
  ) {
    List<Opportunity> oppUpdates = new List<Opportunity>();
    for (TranslAid_Projekt_Event__e newP : newProjekt.values()) {
      TranslAid_Projekt__c p = [
        SELECT Id, Opportunity__c, Status__c
        FROM TranslAid_Projekt__c
        WHERE Id = :newP.TranslAid_Projekt_Id__c
      ];
      Opportunity opp = [
        SELECT Id, Stagename, Lost_Reason__c, Dolmetscher_in__c
        FROM Opportunity
        WHERE Id = :p.Opportunity__c
      ];
      if (newP.Status__c == 'Einsatz erfolgreich beendet') {
        opp.StageName = 'Closed Won';
        oppUpdates.add(opp);
      } else if (newP.Status__c == 'Einsatz von Sprachmittler*in storniert') {
        opp.StageName = 'Open';
        opp.Dolmetscher_in__c = null;
        oppUpdates.add(opp);
      } else if (newP.Status__c == 'Einsatz von Klient*in storniert') {
        opp.StageName = 'Closed Lost';
        opp.Lost_Reason__c = 'Anfrage zurückgezogen';
        oppUpdates.add(opp);
      }
    }
    update oppUpdates;
  }
}
