@isTest(SeeAllData=false)
public class AccountTriggerTest {
  @isTest
  static void testTrigger() {
    Id klientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Fluchtling')
      .getRecordTypeId();
    Account klient = new Account(
      FirstName = 'FirstKlient',
      LastName = 'LastKlient',
      RecordTypeId = klientRecordTypeId,
      Herkunftsland__pc = 'Afghanistan',
      Niveau_C2__pc = 'Deutsch',
      Niveau_C1__pc = 'Deutsch',
      Niveau_B2__pc = 'Deutsch',
      Niveau_B1__pc = 'Deutsch',
      Niveau_A2__pc = 'Deutsch',
      Niveau_A1__pc = 'Deutsch'
    );
    insert klient;
    Account a1 = [
      SELECT id, Sprachniveau__pc
      FROM Account
      WHERE Id = :klient.Id
    ];
    System.assertEquals(
      'C2: Deutsch - C1: Deutsch - B2: Deutsch - B1: Deutsch - A2: Deutsch - A1: Deutsch',
      a1.Sprachniveau__pc,
      'Something is wrong with Account trrigger'
    );
  }
}
