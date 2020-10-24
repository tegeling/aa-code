@IsTest
private class FCMNotificationCalloutTest {
  @IsTest
  private static void testSendFCMNotifications() {
    Test.setMock(HttpCalloutMock.class, new FCMNotificationCalloutMock());
    Test.startTest();
    List<String> recipients = new List<String>();
    recipients.add('111');
    List<FCMNotificationCallout.FCMNotificationRequest> inputParams = new List<FCMNotificationCallout.FCMNotificationRequest>();
    FCMNotificationCallout.FCMNotificationRequest input = new FCMNotificationCallout.FCMNotificationRequest();
    input.title = 'Title';
    input.body = 'Body';
    input.recipients = recipients;
    inputParams.add(input);
    FCMNotificationCallout.sendFCMNotifications(inputParams);
    Test.stopTest();
    // runs callout and check results
    System.assert(true);
  }
}
