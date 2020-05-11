public without sharing class LeadActions {
  public static void translaidSetAktionstermine(List<Lead> newLead) {
    // query all active TranslAid Aktionen
    Id ehrenamtRecordTypeId = Schema.SObjectType.Workshop__c.getRecordTypeInfosByDeveloperName()
      .get('Ehrenamt_Aktion')
      .getRecordTypeId();
    List<Workshop__c> aktionen = [
      SELECT
        Id,
        Name,
        Startdatum__c,
        Start_Uhrzeit__c,
        Aktive_Aktion__c,
        Workshop_Typ__c,
        ArrivalAid_Programm__c,
        Adresse__c
      FROM Workshop__c
      WHERE
        RecordTypeId = :ehrenamtRecordTypeId
        AND Aktive_Aktion__c = true
        AND Workshop_Typ__c = 'TranslAid Einführung'
        AND ArrivalAid_Programm__c = 'TranslAid'
      ORDER BY Startdatum__c
    ];

    // Set Aktionstermine for each Lead
    Id translAidDolmetscherRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName()
      .get('TranslAid_Dolmetscher')
      .getRecordTypeId();
    for (Lead l : newLead) {
      if (l.RecordTypeId == translAidDolmetscherRecordTypeId) {
        l.Aktionstermine__c = '<ul>';
        for (Workshop__c w : aktionen) {
          if (w.Startdatum__c != null && w.Start_Uhrzeit__c != null) {
            String uhrzeit = '' + w.Start_Uhrzeit__c;
            l.Aktionstermine__c +=
              '<li>am ' +
              w.Startdatum__c.format() +
              ' um ' +
              uhrzeit.left(uhrzeit.lastIndexOf(':')) +
              ' Uhr, Ort: ' +
              w.Adresse__c +
              '</li>';
          }
        }
        l.Aktionstermine__c += '</ul>';
      }
    }
  }
}
