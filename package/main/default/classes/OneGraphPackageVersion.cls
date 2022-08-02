@RestResource(urlMapping='/subscriptions-package-version')
global class OneGraphPackageVersion {
  global static Version version = new Version(0, 23, 0);
  global static String versionString = 'v23';

  @HttpGet
  global static void doGet() {
    RestContext.response.addHeader('Content-Type', 'application/json');
    RestContext.response.responseBody = Blob.valueOf(
      String.format(
        '\'{\' "version" : "{0}", "versionString" : "{1}" \'}\'',
        new List<Object>{ version, versionString }
      )
    );
  }
}
