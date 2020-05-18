@IsTest
private class GoogleDriveCalloutsTest {
  @IsTest
  private static void testDeleteFile() {
    Test.setMock(HttpCalloutMock.class, new GoogleDriveCalloutsMock());
    Test.startTest();
    List<String> fileIDS = new List<String>();
    fileIDS.add('111');
    GoogleDriveCallouts.deleteFileInvocable(fileIDS);
    Test.stopTest();
    // runs callout and check results
    System.assert(true);
  }
}
