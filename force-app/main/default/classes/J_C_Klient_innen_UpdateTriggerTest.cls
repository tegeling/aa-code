@isTest(SeeAllData=false)
public class J_C_Klient_innen_UpdateTriggerTest {
  @isTest
  static void testTrigger() {
    Id klientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Fluchtling')
      .getRecordTypeId();
    Account klient = new Account(
      FirstName = 'FirstKlient',
      LastName = 'LastKlient',
      RecordTypeId = klientRecordTypeId
    );
    insert klient;
    J_C_Klient_innen_Update__c klientUpdate = new J_C_Klient_innen_Update__c(
      Klient_in__c = klient.Id,
      Name = 'Klient'
    );
    insert klientUpdate;
    klientUpdate.Name = 'KlientUpdate';
    update klientUpdate;
  }
}
