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
    'Task'
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
}
