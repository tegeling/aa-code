@isTest
global class GoogleDriveCalloutsMock implements HttpCalloutMock {
  global HttpResponse respond(HttpRequest req) {
    // Create a fake response
    HttpResponse res = new HttpResponse();
    res.setHeader('Content-Type', 'application/json');
    res.setBody('{"parents": ["14MC-IImgNdh3crMzcCn0txO7EOjdiEoM"]}');
    res.setStatusCode(200);
    return res;
  }
}
