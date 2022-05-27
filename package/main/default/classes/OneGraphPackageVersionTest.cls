@isTest
private class OneGraphPackageVersionTest {
  public class Response {
    public String version;
    public String versionString;
  }

  @isTest
  static void test() {
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/OneGraph/signing-key-public';
    req.httpMethod = 'GET';

    RestContext.request = req;
    RestContext.response = res;

    Test.startTest();
    OneGraphPackageVersion.doGet();
    Test.stopTest();

    Response response;

    JSONParser parser = JSON.createParser(res.responseBody.toString());

    while (parser.nextToken() != null) {
      if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
        response = (Response) parser.readValueAs(Response.class);
      }
    }

    System.assertEquals(false, response == null, 'Response was null');
    if (response != null) {
      System.assertEquals(
        OneGraphPackageVersion.versionString,
        response.versionString,
        'versionString is incorrect'
      );
    }
  }
}
