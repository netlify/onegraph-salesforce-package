@isTest
private class OneGraphUserTriggerV1Test {
  @isTest
  static void testUserTrigger() {
    new MockUtils().mockHttp();
    Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
    Blob b = Crypto.GenerateAESKey(128);
    String uid = EncodingUtil.ConvertTohex(b);
    Test.startTest();
    User u = new User();
    u.FirstName = 'First';
    u.LastName = 'Last';
    u.Email = 'test-' + uid + '@example.com';
    u.Alias = 'alias';
    u.Username = 'test-' + uid + '@example.com';
    u.TimeZoneSidKey = 'America/New_York';
    u.LocaleSidKey = 'en_US';
    u.EmailEncodingKey = 'UTF-8';
    u.ProfileId = p.id;
    u.LanguageLocaleKey = 'en_US';
    insert u;
    System.assertEquals(Limits.getQueueableJobs(), 1, 'job was not queued');
    Test.stopTest();
  }
}
