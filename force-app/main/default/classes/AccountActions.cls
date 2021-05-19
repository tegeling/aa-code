public with sharing class AccountActions {
  public static void setSprachniveau(List<Account> newAccount) {
    // Set Sprachniveau based on multiselect picklist values
    Id klientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Fluchtling')
      .getRecordTypeId();
    for (Account klient : newAccount) {
      if (klient.RecordTypeId == klientRecordTypeId) {
        List<String> niveaus = new List<String>();
        if (!String.isBlank(klient.Niveau_C2__pc)) {
          niveaus.add('C2: ' + klient.Niveau_C2__pc);
        }
        if (!String.isBlank(klient.Niveau_C1__pc)) {
          niveaus.add('C1: ' + klient.Niveau_C1__pc);
        }
        if (!String.isBlank(klient.Niveau_B2__pc)) {
          niveaus.add('B2: ' + klient.Niveau_B2__pc);
        }
        if (!String.isBlank(klient.Niveau_B1__pc)) {
          niveaus.add('B1: ' + klient.Niveau_B1__pc);
        }
        if (!String.isBlank(klient.Niveau_A2__pc)) {
          niveaus.add('A2: ' + klient.Niveau_A2__pc);
        }
        if (!String.isBlank(klient.Niveau_A1__pc)) {
          niveaus.add('A1: ' + klient.Niveau_A1__pc);
        }
        klient.Sprachniveau__pc = String.join(niveaus, ' - ');
      }
    }
  }
}
