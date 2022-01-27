@isTest
private class SigningKeyTest {
  @isTest
  static void testGetChunk() {
    String testString = 'ABCDEFGHIJKLMNOP';

    System.assertEquals(
      SigningKey.getChunk(3, testString, 0),
      'ABC',
      'bad chunk'
    );
    System.assertEquals(
      SigningKey.getChunk(3, testString, 1),
      'DEF',
      'bad chunk'
    );
    System.assertEquals(
      SigningKey.getChunk(3, testString, 2),
      'GHI',
      'bad chunk'
    );
    System.assertEquals(
      SigningKey.getChunk(3, testString, 3),
      'JKL',
      'bad chunk'
    );
    System.assertEquals(
      SigningKey.getChunk(3, testString, 4),
      'MNO',
      'bad chunk'
    );
    System.assertEquals(
      SigningKey.getChunk(3, testString, 5),
      'P',
      'bad chunk'
    );
    System.assertEquals(SigningKey.getChunk(3, testString, 6), '', 'bad chunk');
    System.assertEquals(SigningKey.getChunk(3, testString, 7), '', 'bad chunk');
    System.assertEquals(SigningKey.getChunk(3, testString, 8), '', 'bad chunk');
    System.assertEquals(SigningKey.getChunk(3, testString, 9), '', 'bad chunk');
  }

  @isTest
  static void testInsertSigningKey() {
    Test.setMock(HttpCalloutMock.class, new OneGraphCalloutMockV1());
    Map<String, String> keyMap = SigningKey.fetchKeyMap();
    Test.startTest();
    SigningKey.insertSigningKey(keyMap);
    Map<String, String> fakeKeyMap = new Map<String, String>();
    fakeKeyMap.put('privateKey', 'asdf');
    fakeKeyMap.put('publicKey', 'adsf');
    Map<String, String> afterInsertMap = SigningKey.keyMapOfSigningKey(
      SigningKey.insertSigningKey(fakeKeyMap)
    );
    System.assertEquals(
      afterInsertMap.get('privateKey'),
      keyMap.get('privateKey'),
      'incorrect private key after re-insert'
    );
    System.assertEquals(
      afterInsertMap.get('publicKey'),
      keyMap.get('publicKey'),
      'incorrect public key after re-insert'
    );
    System.assertEquals(
      SigningKey.getPublicKey(),
      keyMap.get('publicKey'),
      'incorrect public key after re-insert'
    );

    Test.stopTest();
  }

  @isTest
  static void testSignature() {
    new MockUtils().mockHttp();
    Test.startTest();
    Long timestamp = Long.valueOf('1614908155969');
    String expect = 't=1614908155969,v2=5226592a8dade3267c559d9854108ed7cf27f6185f7c148a20573f6f536ddf712036bcd35a8907322d5231efcbd77933d7f22e2a7b68b5ee80311c74fe7a739a45e4f85d92dd436b0b55d8fd489adc931b9fcfa34894757f0d8862905df7e6ff625e7a75af14cffb16d6c0ed22d3f0bc9b15dc1fd6ec7ca33f103bbe9b35af3c02dbe4f5707689a27e5f3947cbc567f69387422be94db5e5c0361e0447f5e24d9192c620addbfa9f9c6ac186df8db88d9b3e32e485e35f4bbe789eac41846cbc27b4bd552237dc851b1b90d5ae7a858605ac947eec7222c77acea2c5dd4753adad1a4c276c53f1c4e1a0d6128e6c80ac0080c5626f7d79cb5c2c5bd398767c2b';

    System.assertEquals(
      SigningKey.getSignature(timestamp, 'test_content'),
      expect,
      'incorrect signature'
    );
    Test.stopTest();
  }
}
