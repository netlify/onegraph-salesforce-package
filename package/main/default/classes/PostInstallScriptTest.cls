@isTest
private class PostInstallScriptTest {
  @isTest
  static void testInstallScriptOnNewInstance() {
    PostInstallScript postinstall = new PostInstallScript();
    Test.testInstall(postinstall, null);
    OneGraph__TriggerToggle__c triggerToggles = OneGraph__TriggerToggle__c.getInstance(
      UserInfo.getUserId()
    );

    System.assertEquals(
      true,
      triggerToggles.Disable_Account_Insert_Trigger__c,
      'Individual triggers should be disabled.'
    );

    System.assertEquals(
      false,
      triggerToggles.Disable_All_Account_Triggers__c,
      'DisableAll toggle for an sobject should not be disabled.'
    );

    System.assertEquals(
      false,
      triggerToggles.Disable_All_Triggers__c,
      'DisableAll toggle should not be disabled.'
    );
  }

  @isTest
  static void testInstallScriptOnUpgrade() {
    PostInstallScript postinstall = new PostInstallScript();
    Test.testInstall(postinstall, new Version(1, 0));
    OneGraph__TriggerToggle__c triggerToggles = OneGraph__TriggerToggle__c.getInstance(
      UserInfo.getUserId()
    );

    System.assertEquals(
      false,
      triggerToggles.Disable_Account_Insert_Trigger__c,
      'Individual triggers should not be disabled on upgrade from pre-v24.'
    );

    System.assertEquals(
      false,
      triggerToggles.Disable_All_Account_Triggers__c,
      'DisableAll toggle for an sobject should not be disabled.'
    );

    System.assertEquals(
      false,
      triggerToggles.Disable_All_Triggers__c,
      'DisableAll toggle should not be disabled.'
    );
  }
}
