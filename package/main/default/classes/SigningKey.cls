@namespaceAccessible
public without sharing class SigningKey implements Database.AllowsCallouts {
  private static String webhookUniqueKey = 'webhook_signing_key';
  private static Integer fieldSize = 255;

  @TestVisible
  private static Map<String, String> keyMapOfSigningKey(
    OneGraph__CalloutSigningKey__c signingKey
  ) {
    List<String> privateKeySegments = new List<String>{
      signingKey.OneGraph__PrivateKeySegment0__c,
      signingKey.OneGraph__PrivateKeySegment1__c,
      signingKey.OneGraph__PrivateKeySegment2__c,
      signingKey.OneGraph__PrivateKeySegment3__c,
      signingKey.OneGraph__PrivateKeySegment4__c,
      signingKey.OneGraph__PrivateKeySegment5__c,
      signingKey.OneGraph__PrivateKeySegment6__c,
      signingKey.OneGraph__PrivateKeySegment7__c,
      signingKey.OneGraph__PrivateKeySegment8__c,
      signingKey.OneGraph__PrivateKeySegment9__c
    };
    List<String> publicKeySegments = new List<String>{
      signingKey.OneGraph__PublicKeySegment0__c,
      signingKey.OneGraph__PublicKeySegment1__c,
      signingKey.OneGraph__PublicKeySegment2__c,
      signingKey.OneGraph__PublicKeySegment3__c,
      signingKey.OneGraph__PublicKeySegment4__c
    };
    Map<String, String> keyMap = new Map<String, String>();
    keyMap.put('privateKey', String.join(privateKeySegments, ''));
    keyMap.put('publicKey', String.join(publicKeySegments, ''));
    return keyMap;
  }

  // The `chunk` parameter represents the index of the list of
  // strings if the string was split into chunks of 255 characters
  // Returns '' for chunks past the end of the string
  @TestVisible
  private static String getChunk(Integer chunkSize, String s, Integer chunk) {
    Integer chunkStart = chunk * chunkSize;
    Integer chunkEnd = chunkStart + chunkSize;
    Integer maxIndex = s.length();

    Integer startIndex = chunkStart > maxIndex ? maxIndex : chunkStart;
    Integer endIndex = Math.min(chunkEnd, maxIndex);

    return s.substring(startIndex, endIndex);
  }

  private static OneGraph__CalloutSigningKey__c getSigningKey() {
    List<OneGraph__CalloutSigningKey__c> existingSigningKeys = [
      SELECT
        OneGraph__PrivateKeySegment0__c,
        OneGraph__PrivateKeySegment1__c,
        OneGraph__PrivateKeySegment2__c,
        OneGraph__PrivateKeySegment3__c,
        OneGraph__PrivateKeySegment4__c,
        OneGraph__PrivateKeySegment5__c,
        OneGraph__PrivateKeySegment6__c,
        OneGraph__PrivateKeySegment7__c,
        OneGraph__PrivateKeySegment8__c,
        OneGraph__PrivateKeySegment9__c,
        OneGraph__PublicKeySegment0__c,
        OneGraph__PublicKeySegment1__c,
        OneGraph__PublicKeySegment2__c,
        OneGraph__PublicKeySegment3__c,
        OneGraph__PublicKeySegment4__c
      FROM OneGraph__CalloutSigningKey__c
      WHERE OneGraph__EnsureSingleton__c = :webhookUniqueKey
    ];

    if (existingSigningKeys.isEmpty()) {
      return null;
    } else {
      return existingSigningKeys[0];
    }
  }

  @TestVisible
  private static OneGraph__CalloutSigningKey__c insertSigningKey(
    Map<String, String> keyMap
  ) {
    String priv = keyMap.get('privateKey');
    String pub = keyMap.get('publicKey');

    OneGraph__CalloutSigningKey__c signingKey = new OneGraph__CalloutSigningKey__c(
      OneGraph__PrivateKeySegment0__c = getChunk(fieldSize, priv, 0),
      OneGraph__PrivateKeySegment1__c = getChunk(fieldSize, priv, 1),
      OneGraph__PrivateKeySegment2__c = getChunk(fieldSize, priv, 2),
      OneGraph__PrivateKeySegment3__c = getChunk(fieldSize, priv, 3),
      OneGraph__PrivateKeySegment4__c = getChunk(fieldSize, priv, 4),
      OneGraph__PrivateKeySegment5__c = getChunk(fieldSize, priv, 5),
      OneGraph__PrivateKeySegment6__c = getChunk(fieldSize, priv, 6),
      OneGraph__PrivateKeySegment7__c = getChunk(fieldSize, priv, 7),
      OneGraph__PrivateKeySegment8__c = getChunk(fieldSize, priv, 8),
      OneGraph__PrivateKeySegment9__c = getChunk(fieldSize, priv, 9),
      OneGraph__PublicKeySegment0__c = getChunk(fieldSize, pub, 0),
      OneGraph__PublicKeySegment1__c = getChunk(fieldSize, pub, 1),
      OneGraph__PublicKeySegment2__c = getChunk(fieldSize, pub, 2),
      OneGraph__PublicKeySegment3__c = getChunk(fieldSize, pub, 3),
      OneGraph__PublicKeySegment4__c = getChunk(fieldSize, pub, 4),
      OneGraph__EnsureSingleton__c = webhookUniqueKey
    );
    try {
      // No need to check permission on insert here because the only thing that
      // can be inserted is a random rsa key pair generated through the https callout
      // to the OneGraph web service
      insert signingKey;
      return signingKey;
    } catch (DmlException dmlException) {
      OneGraph__CalloutSigningKey__c existingsigningKey = getSigningKey();
      if (existingsigningKey == null) {
        CalloutException e = new CalloutException();
        e.setMessage('Signing key not found after insert failed.');
        throw e;
      }
      return existingsigningKey;
    }
  }

  // Makes API call to OneGraph to fetch a new, random rsa key
  // OneGraph does not store or log the key
  @TestVisible
  private static Map<String, String> fetchKeyMap() {
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setCompressed(true);
    req.setEndpoint(
      'callout:OneGraph__Callout/salesforce/package-setup/genkey'
    );
    req.setMethod('POST');
    req.setHeader('Content-Type', 'application/json');
    req.setBody('');
    HTTPResponse res = h.send(req);
    if (res.getStatusCode() != 200) {
      System.debug(
        LoggingLevel.ERROR,
        String.format(
          'Error generating private key on OneGraph, statusCode={0}, statusMessage={1}',
          new List<Object>{ res.getStatusCode(), res.getStatus() }
        )
      );
      CalloutException e = new CalloutException();
      e.setMessage('Unable to generate signing key');
      throw e;
    } else {
      String body = res.getBody();
      Map<String, Object> json = (Map<String, Object>) JSON.deserializeUntyped(
        body
      );

      String privateKey = (String) json.get('privateKey');
      String publicKey = (String) json.get('publicKey');

      Map<String, String> keyMap = new Map<String, String>();
      keyMap.put('privateKey', privateKey);
      keyMap.put('publicKey', publicKey);
      return keyMap;
    }
  }

  @TestVisible
  private static Map<String, String> generateKeyMap() {
    Map<String, String> keyMap = fetchKeyMap();
    OneGraph__CalloutSigningKey__c signingKey = insertSigningKey(keyMap);
    return keyMapOfSigningKey(signingKey);
  }

  private static Map<String, String> findOrCreateKeyMap() {
    OneGraph__CalloutSigningKey__c existingSigningKey = getSigningKey();
    if (existingSigningKey == null) {
      return generateKeyMap();
    } else {
      return keyMapOfSigningKey(existingSigningKey);
    }
  }

  private static Blob getPrivateKey() {
    Map<String, String> keyMap = findOrCreateKeyMap();
    return EncodingUtil.base64Decode(keyMap.get('privateKey'));
  }

  @namespaceAccessible
  public static String getSignature(Long timestamp, String content) {
    Blob key = getPrivateKey();
    Blob payload = Blob.valueOf(
      String.format('{0}.{1}', new List<Object>{ timestamp, content })
    );
    String v2Signature = EncodingUtil.convertToHex(
      Crypto.sign('RSA-SHA256', payload, key)
    );

    String signature = String.format(
      't={0},v2={1}',
      new List<Object>{ timestamp, v2Signature }
    );
    return signature;
  }

  public static String getPublicKey() {
    Map<String, String> keyMap = findOrCreateKeyMap();
    return keyMap.get('publicKey');
  }
}
