@isTest(SeeAllData=false)
public class AnonymizerActionsTest {
  @isTest
  static void testDeleteChatterFeedItems() {
    // Get Record Type Ids
    Id klientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Fluchtling')
      .getRecordTypeId();
    // create test records
    Account klient = new Account(
      FirstName = 'Vorname',
      LastName = 'Nachname',
      RecordTypeId = klientRecordTypeId
    );
    insert klient;
    FeedItem post = new FeedItem(ParentId = klient.Id);
    List<String> records = new List<String>();
    records.add(klient.Id);
    // run test
    Test.startTest();
    AnonymizerActions.deleteChatterFeedItems(records);
    Test.stopTest();
    List<FeedItem> posts = [
      SELECT Id
      FROM FeedItem
      WHERE parentId = :klient.Id
    ];
    System.assertEquals(posts.size(), 0);
  }
}
