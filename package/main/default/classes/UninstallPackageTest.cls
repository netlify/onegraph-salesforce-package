@isTest
private class UninstallPackageTest {
  @isTest
  static void testUninstallScript() {
    MockUtils m = new MockUtils();
    m.mockHttp();
    Test.startTest();
    Test.testUninstall(new UninstallPackage());
    System.assertEquals(
      'callout:OneGraph__Callout/salesforce/package-setup/uninstall',
      m.getLastRequest().getEndpoint(),
      'uninstall package did not call out'
    );
    Test.stopTest();
  }
}
