public class FCMNotificationCallout {
  @future(callout=true)
  public static void sendNotification(
    String title,
    String body,
    List<String> recipients
  ) {
    // Get settings from metadata
    FCM_Setting__mdt settings = [
      SELECT Authorization_Key__c
      FROM FCM_Setting__mdt
      WHERE DeveloperName = 'TranslAid'
    ];

    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('callout:FCM_API');
    request.setHeader('Content-Type', 'application/json');
    request.setHeader('Authorization', 'key=' + settings.Authorization_Key__c);
    request.setMethod('POST');
    List<String> registrationIds = new List<String>();
    for (String recipient : recipients) {
      registrationIds.add('"' + recipient + '"');
    }
    String requestBody = '{';
    requestBody += '"registration_ids":';
    requestBody += '[';
    requestBody += String.join(registrationIds, ',');
    requestBody += '],';
    requestBody +=
      '"notification": {"body": "' +
      body +
      '", "title": "' +
      title +
      '"}';
    requestBody += '}';
    request.setBody(requestBody);
    HttpResponse response = http.send(request);
  }
  public class FCMNotificationRequest {
    @InvocableVariable(
      label='Notification Title'
      description='String title'
      required=true
    )
    public String title;
    @InvocableVariable(
      label='Notification Body'
      description='String body'
      required=true
    )
    public String body;
    @InvocableVariable(
      label='Recipients Ids'
      description='String list of FCM registration ids'
      required=true
    )
    public List<String> recipients;
  }

  @InvocableMethod(label='Send FCM Notification Messages')
  public static void sendFCMNotifications(
    List<FCMNotificationRequest> inputParams
  ) {
    for (FCMNotificationRequest p : inputParams) {
      sendNotification(p.title, p.body, p.recipients);
    }
  }
}
