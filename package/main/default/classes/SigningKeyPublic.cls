@RestResource(urlMapping='/signing-key-public')
global class SigningKeyPublic implements Database.AllowsCallouts {
  global static String getPublicKey() {
    return SigningKey.getPublicKey();
  }

  @HttpGet
  global static String doGet() {
    return SigningKey.getPublicKey();
  }
}
