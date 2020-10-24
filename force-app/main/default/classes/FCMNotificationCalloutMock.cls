@isTest
global class FCMNotificationCalloutMock implements HttpCalloutMock {
  global HttpResponse respond(HttpRequest req) {
    // Create a fake response
    HttpResponse res = new HttpResponse();
    res.setHeader('Content-Type', 'application/json');
    res.setStatusCode(200);
    return res;
  }
}
