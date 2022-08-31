@isTest
private class OneGraphToggleSettingsTest {
  private static List<String> sobjects = new List<String>{
    'Account',
    'Case',
    'CaseComment',
    'Contact',
    'Event',
    'FeedComment',
    'FeedItem',
    'Lead',
    'Opportunity',
    'Task',
    'User'
  };
  private static List<String> triggerTypes = new List<String>{
    'insert',
    'update',
    'delete',
    'undelete'
  };

  @isTest
  static void allDisabledForSobjectDefaultsToFalse() {
    OneGraph__TriggerToggle__c triggerToggles = OneGraph__TriggerToggle__c.getInstance();

    for (String sobjectName : sobjects) {
      System.assertEquals(
        OneGraphToggleSettings.allDisabledForSobject(
          triggerToggles,
          sobjectName
        ),
        false,
        'incorrect default'
      );
    }
  }

  @isTest
  static void triggerDisabledForSobjectDefaultsToFalse() {
    OneGraph__TriggerToggle__c triggerToggles = OneGraph__TriggerToggle__c.getInstance();

    for (String sobjectName : sobjects) {
      for (String triggerType : triggerTypes) {
        System.assertEquals(
          OneGraphToggleSettings.triggerDisabledForSobject(
            triggerToggles,
            sobjectName,
            triggerType
          ),
          false,
          'incorrect default'
        );
      }
    }
  }

  @isTest
  static void setAllForSobjectTest() {
    OneGraph__TriggerToggle__c triggerToggles = OneGraph__TriggerToggle__c.getInstance();

    for (String sobjectName : sobjects) {
      OneGraphToggleSettings.setAllForSobject(
        triggerToggles,
        sobjectName.toLowerCase(),
        true
      );

      System.assertEquals(
        true,
        OneGraphToggleSettings.allDisabledForSobject(
          triggerToggles,
          sobjectName
        ),
        'incorrect value after setting ' + sobjectName
      );
    }
  }

  @isTest
  static void setTriggerForSobjectTest() {
    OneGraph__TriggerToggle__c triggerToggles = OneGraph__TriggerToggle__c.getInstance();

    for (String sobjectName : sobjects) {
      for (String triggerType : triggerTypes) {
        OneGraphToggleSettings.setTriggerForSobject(
          triggerToggles,
          sobjectName.toLowerCase(),
          triggerType,
          true
        );
        System.assertEquals(
          true,
          OneGraphToggleSettings.triggerDisabledForSobject(
            triggerToggles,
            sobjectName,
            triggerType
          ),
          'incorrect value after setting ' +
          sobjectName +
          ' ' +
          triggerType
        );
      }
    }
  }
}
