public without sharing class AnonymizerActions {
  @InvocableMethod(
    label='Delete Chatter Feed Items'
    description='Delete chatter posts for a given Salesforce record.'
  )
  public static void deleteChatterFeedItems(List<String> recordList) {
    // list FeedItems to delete
    List<FeedItem> deletePosts = new List<FeedItem>();
    for (Id record : recordList) {
      List<FeedItem> curPosts = [
        SELECT Id
        FROM FeedItem
        WHERE parentId = :record
      ];
      deletePosts.addAll(curPosts);
    }
    delete deletePosts;
  }
}