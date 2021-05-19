public with sharing class AccountActions {
  public static void setSprachniveau(List<Account> newAccount) {
    // Set Sprachniveau based on multiselect picklist values
    Id klientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Fluchtling')
      .getRecordTypeId();
    for (Account klient : newAccount) {
      if (klient.RecordTypeId == klientRecordTypeId) {
        String sprachniveau = '';
        if (!klient.Niveau_C2__pc.isBlank()) {
          sprachniveau += 'C2: ';
          sprachniveau += klient.Niveau_C2__pc;
        }
        /*
        String a1 = 'A1: ';
        String a2 = 'A2: ';
        String b1 = 'B1: ';
        String b2 = 'B2: ';
        String c1 = 'C1: ';
        String c2 = 'C2: ';
          */
        klient.Sprachniveau__pc = sprachniveau;
      }
    }
  }
}
