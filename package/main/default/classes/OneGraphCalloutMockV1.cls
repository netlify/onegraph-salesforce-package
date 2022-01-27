@isTest
global class OneGraphCalloutMockV1 implements HttpCalloutMock {
  // Random key that is not in use anywhere
  private static String genKeyBody = '{"privateKey":"MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDKPMWtZh8YiiL9r5PtwlNOA82QirsCXu6NcBiHsfl47qdWhjZF5utSD+EIgx0v2msPPWEUQj7yLvgpuQ9BAhfzky03szXwMNM7cR5pD0ubKw7Kb7rDB1EvMUMul6no+pKrsuimJpgbOens0enghpbVuW1l4is3lsNZH1/DzT+qVgYKvsbdY9GlbWrwQPVltwB9rQr7AAUmdMO7/30KgS4mRAyQ1ZPqROhtjX37Vx+ICIOnN1Y+Fn/6gXQcwB9osfp512kv86MkSdIC3ds8EtVLvPm/XamNT9RI1FLb1VjNwSyfr3gMk3kNJOaluH2Bv8NQKGCKOSqZrFoiqHTFqSX3AgMBAAECggEAEo4i4Pb2sWyzKy152B21QPouWS2xXNVS890uEv0sU4EqD1E/F4jJXH0ie4J0IhjbK8nI52/wkI3orQNSt/c2NV3yjyK9Ny1zpAeL7728hR8dO0unCg/YzgiqDlNR/pNG88P1fpEZ8Z2NrfHQkI4otrFNrURkDLSjdcDgK3ngdoNGPvWhYr3SwO7kuLuPItljWJqXWkbGOVurw9EqRl4UrgYX515ElgaGMw5AbSE6870MiM21JYr6If73AKwHH0XS+A4fuXIevSlWz8rbiu+0R0i2KRbbPCuxXYzY0KrikxOJu4vOZqx0Tbce/i2HQQlmTRMZcsbu5g37Tdo/YV0uuQKBgQDs9n8GrUTXdUM8qDKjbaU4EZeOXfRi1g68NJAiw25xd5QJ11B6qOSuu+5zyMF46XAkwsYh0YhV0BNfkQk/5RLeA5RmeEoH+uxGjhbhLkIypva35rpvpq5h7weT//QMlQtTeG35mbIM8gGTpblZQOiTImZVk8INReuo6JeD3w4q7QKBgQDafBfi6bGq7MjT6XGRFunh4c4MemJsBqoD+X6s7zodykkRmyg0Ba6Nf4jWieBzXHohl2oun43haD5whZ/6EVqkJttEIUvZb5whWuf1KquAVERCMgAm/ygWNZo8mhKhlbsM65YMiq+RkHR7xgfZ2gnAkiyKsPez/6F4T9c+Jbgj8wKBgQDK8VFZJowO+x7alDLKRN17Z5WlGFJ1U17LUTkgjL/J7d+bjgwfAQbZn5pZD1ajd0nUMfv+erWIyOvOrSh+0HGYMvilyd+ddgllY8u0jymit9wVJEYH2Xj/5vdWiZ86J2vL0Rhe7ILRE3LGQOi8yBpn6M47/I/1TizGPG2HQ0GfAQKBgQDEzHJXmljGtXJQLz50ikcxh8upwbNVysrpuZo4+2NF4iffC/syoMuR+Qaw+JCMWQhJqbGjPWT3XIahpDttbKRQqA9pVvSTbs0b3l6Bn2XLuhuh5JfuiHb7Sl0bqUyO7+gEw0/tDB8I5y2FL+Nyf8u5AfHNG4qDQAeZ75DaEe/DsQKBgAlGGapApXGJLK6aRVK5gve8MKRjWNVU1GrOY6jYi4xyXSxsEe90x2cSrfz/uPgX6xoohYtOMmWHIBcr/srUWhzgnKqxrecAAoEdMxnumS4PkxBqFM6V2CL9Vua9W3/6tuQYhkiLkRY6dOYJbEHa0YObvWeEFdJtqhSK8+YU9Jrh","publicKey":"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyjzFrWYfGIoi/a+T7cJTTgPNkIq7Al7ujXAYh7H5eO6nVoY2RebrUg/hCIMdL9prDz1hFEI+8i74KbkPQQIX85MtN7M18DDTO3EeaQ9LmysOym+6wwdRLzFDLpep6PqSq7LopiaYGznp7NHp4IaW1bltZeIrN5bDWR9fw80/qlYGCr7G3WPRpW1q8ED1ZbcAfa0K+wAFJnTDu/99CoEuJkQMkNWT6kTobY19+1cfiAiDpzdWPhZ/+oF0HMAfaLH6eddpL/OjJEnSAt3bPBLVS7z5v12pjU/USNRS29VYzcEsn694DJN5DSTmpbh9gb/DUChgijkqmaxaIqh0xakl9wIDAQAB"}';
  private Integer failWebhookRequestCount = 0;
  private Integer webhookCalloutCount = 0;
  private static String webhookEndpoint = 'callout:OneGraph__Callout/webhooks/salesforce';

  private List<HttpRequest> requests = new List<HttpRequest>{};

  public OneGraphCalloutMockV1() {
    this(0);
  }

  public OneGraphCalloutMockV1(Integer failWebhookRequestCount) {
    this.failWebhookRequestCount = failWebhookRequestCount;
  }

  private static String getBody(HttpRequest req) {
    switch on req.getMethod() {
      when 'POST' {
        switch on req.getEndpoint() {
          when 'callout:OneGraph__Callout/salesforce/package-setup/genkey' {
            return genKeyBody;
          }
          when else {
            return 'Ok';
          }
        }
      }
      when else {
        return 'Ok';
      }
    }
  }

  public List<HTTPRequest> getMockedRequests() {
    return requests;
  }

  public List<HTTPRequest> getWebhookRequests() {
    List<HttpRequest> filtered = new List<HttpRequest>();
    for (HttpRequest req : requests) {
      if (req.getEndpoint() == webhookEndpoint) {
        filtered.add(req);
      }
    }
    return filtered;
  }

  global HttpResponse respond(HTTPRequest req) {
    this.requests.add(req);
    HttpResponse res = new HttpResponse();
    //res.setStatus('OK');
    res.setStatusCode(
      req.getEndpoint() == webhookEndpoint &&
        this.webhookCalloutCount < this.failWebhookRequestCount
        ? 500
        : 200
    );
    res.setBody(getBody(req));
    if (req.getEndpoint() == webhookEndpoint) {
      this.webhookCalloutCount = this.webhookCalloutCount + 1;
    }
    return res;
  }
}
