@isTest
public class MockUtils {
  private OneGraphCalloutMockV1 calloutMock;
  private Integer failWebhookRequestCount = 0;

  public MockUtils() {
    this(0);
  }

  public MockUtils(Integer failWebhookRequestCount) {
    OneGraphWebhookV1.sendCalloutDuringTest = true;
    this.failWebhookRequestCount = failWebhookRequestCount;
    this.calloutMock = new OneGraphCalloutMockV1(failWebhookRequestCount);
  }

  public void mockHttp() {
    Test.setMock(HttpCalloutMock.class, this.calloutMock);
    SigningKeyPublic.getPublicKey();
  }

  public List<HttpRequest> getMockedRequests() {
    return calloutMock.getMockedRequests();
  }

  public List<HttpRequest> getWebhookRequests() {
    return calloutMock.getWebhookRequests();
  }

  public HttpRequest getLastRequest() {
    List<HttpRequest> requests = calloutMock.getMockedRequests();
    return requests.get(requests.size() - 1);
  }
}
