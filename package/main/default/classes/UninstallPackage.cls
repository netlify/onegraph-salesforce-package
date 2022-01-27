global class UninstallPackage implements UninstallHandler, Database.AllowsCallouts {
  global void onUninstall(UninstallContext ctx) {
    String orgId = ctx.organizationId();
    String content = EncodingUtil.convertToHex(Crypto.generateAesKey(256));
    Long timestamp = DateTime.now().getTime();
    String signature = SigningKey.getSignature(timestamp, content);
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint(
      'callout:OneGraph__Callout/salesforce/package-setup/uninstall'
    );
    req.setMethod('POST');
    req.setHeader('Content-Type', 'application/json');
    req.setHeader('x-salesforce-organization-id', orgId);
    req.setHeader('x-salesforce-signature', signature);
    req.setBody(content);
    HTTPResponse res = h.send(req);
    if (res.getStatusCode() != 200) {
      System.debug(
        LoggingLevel.ERROR,
        String.format(
          'Error sending webhook to OneGraph, url={0}, statusCode={1}, statusMessage={2}',
          new List<Object>{
            '/salesforce/package-setup/uninstall',
            res.getStatusCode(),
            res.getStatus()
          }
        )
      );
    }
  }
}
