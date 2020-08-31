public with sharing class Begleiter_inActions {
  public static void setBegleiter_in(List<Begleiter_in__c> newBegleiter_in) {
    // for each Begleiter*in update email field in the related Begleitung
    Map<Id, Begleitung__c> updateBegleitung = new Map<Id, Begleitung__c>();
    for (Begleiter_in__c b : newBegleiter_in) {
      // select Begleitung
      Begleitung__c begleitung = [
        SELECT Email_Angaben_Begleiter_innen__c
        FROM Begleitung__c
        WHERE Id = :b.Begleitung__c
      ];
      // select all related Begleiter_in
      List<Begleiter_in__c> allBegleiter_in = [
        SELECT
          Rolle__c,
          Ehrenamtliche_r__r.FirstName,
          Ehrenamtliche_r__r.LastName,
          Ehrenamtliche_r__r.Email,
          Ehrenamtliche_r__r.MobilePhone,
          Ehrenamtliche_r__r.Phone
        FROM Begleiter_in__c
        WHERE Begleitung__c = :b.Begleitung__c
        ORDER BY Rolle__c
      ];
      String emailtext = null;

      for (Begleiter_in__c oneBegleiter : allBegleiter_in) {
        if (emailtext == null) {
          emailtext =
            oneBegleiter.Rolle__c +
            ': ' +
            oneBegleiter.Ehrenamtliche_r__r.FirstName +
            ' ' +
            oneBegleiter.Ehrenamtliche_r__r.LastName +
            ', ' +
            oneBegleiter.Ehrenamtliche_r__r.Email;
          if (oneBegleiter.Ehrenamtliche_r__r.MobilePhone != null) {
            emailtext =
              emailtext +
              ', ' +
              oneBegleiter.Ehrenamtliche_r__r.MobilePhone;
          }
          if (oneBegleiter.Ehrenamtliche_r__r.Phone != null) {
            emailtext =
              emailtext +
              ', ' +
              oneBegleiter.Ehrenamtliche_r__r.Phone;
          }
        } else {
          emailtext =
            emailtext +
            '\n' +
            oneBegleiter.Rolle__c +
            ': ' +
            oneBegleiter.Ehrenamtliche_r__r.FirstName +
            ' ' +
            oneBegleiter.Ehrenamtliche_r__r.LastName +
            ', ' +
            oneBegleiter.Ehrenamtliche_r__r.Email;
          if (oneBegleiter.Ehrenamtliche_r__r.MobilePhone != null) {
            emailtext =
              emailtext +
              ', ' +
              oneBegleiter.Ehrenamtliche_r__r.MobilePhone;
          }
          if (oneBegleiter.Ehrenamtliche_r__r.Phone != null) {
            emailtext =
              emailtext +
              ', ' +
              oneBegleiter.Ehrenamtliche_r__r.Phone;
          }
        }
      }
      begleitung.Email_Angaben_Begleiter_innen__c = emailtext;
      updateBegleitung.put(begleitung.Id, begleitung);
    }
    update updateBegleitung.values();
  }
}
