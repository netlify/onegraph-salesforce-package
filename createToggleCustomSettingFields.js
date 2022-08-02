const fs = require('fs');

function capitalize(s) {
  return s.charAt(0).toUpperCase() + s.slice(1);
}

function lowerFirst(s) {
  return s.charAt(0).toLowerCase() + s.slice(1);
}

function fieldNameOfTrigger(trigger) {
  switch (trigger) {
    case 'insert':
      return 'Created';
    case 'update':
      return 'Updated';
    case 'delete':
      return 'Deleted';
    case 'undelete':
      return 'Undeleted';
    default:
      throw new Error(`Unknown trigger ${trigger}`);
  }
}

function xmlBody(trigger, sobject) {
  const desc = `Disables the Apex trigger for ${sobject} ${trigger.toLowerCase()}s. If this is checked, then ${lowerFirst(
    sobject,
  )}${fieldNameOfTrigger(trigger)} subscriptions will not be available.`;
  return `<?xml version="1.0" encoding="UTF-8"?>
<CustomField xmlns="http://soap.sforce.com/2006/04/metadata">
    <fullName>Disable_${sobject}_${capitalize(trigger)}_Trigger__c</fullName>
    <defaultValue>false</defaultValue>
        <description>${desc}</description>
    <externalId>false</externalId>
    <inlineHelpText>${desc}</inlineHelpText>
    <label>Disable ${sobject} ${capitalize(trigger)} Trigger</label>
    <trackTrending>false</trackTrending>
    <type>Checkbox</type>
</CustomField>`;
}

function fileName(trigger, sobject) {
  return `Disable_${sobject}_${capitalize(trigger)}_Trigger__c.field-meta.xml`;
}

function disableAllXmlBody(sobject) {
  const desc = `Disables all Apex triggers for ${sobject}. If this is checked, then no subscriptions on ${sobject} will be available.`;
  return `<?xml version="1.0" encoding="UTF-8"?>
<CustomField xmlns="http://soap.sforce.com/2006/04/metadata">
    <fullName>Disable_All_${sobject}_Triggers__c</fullName>
    <defaultValue>false</defaultValue>
        <description>${desc}</description>
    <externalId>false</externalId>
    <inlineHelpText>${desc}</inlineHelpText>
    <label>Disable All ${sobject} Triggers</label>
    <trackTrending>false</trackTrending>
    <type>Checkbox</type>
</CustomField>`;
}

function disableAllFileName(sobject) {
  return `Disable_All_${sobject}_Triggers__c.field-meta.xml`;
}

const sobjects = [
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
  'User',
];

const triggers = ['insert', 'update', 'delete', 'undelete'];

const testList = sobjects.map((sobject) => `    '${sobject}'`).join(',\n');

const toggleSettingsTestBody = `@isTest
private class OneGraphToggleSettingsTest {
  private static List<String> sobjects = new List<String>{
${testList}
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
}`;

const allDisabledForSobject = sobjects
  .map((sobject) => {
    return `      when '${sobject}' {
        return triggerToggles.Disable_All_${sobject}_Triggers__c;
      }`;
  })
  .join('\n');

const triggerDisabledForSobject = sobjects
  .map((sobject) => {
    return `      when '${sobject}' {
        switch on triggerType {
          when 'insert' {
            return triggerToggles.Disable_${sobject}_Insert_Trigger__c;
          }
          when 'update' {
            return triggerToggles.Disable_${sobject}_Update_Trigger__c;
          }
          when 'delete' {
            return triggerToggles.Disable_${sobject}_Delete_Trigger__c;
          }
          when 'undelete' {
            return triggerToggles.Disable_${sobject}_Undelete_Trigger__c;
          }
          when else {
            return false;
          }
        }
      }`;
  })
  .join('\n');

const toggleSettingsBody = `@namespaceAccessible
public without sharing class OneGraphToggleSettings {
  @TestVisible
  private static Boolean allDisabledForSobject(
    OneGraph__TriggerToggle__c triggerToggles,
    String sobjectName
  ) {
    switch on sobjectName {
${allDisabledForSobject}
      when else {
        return false;
      }
    }
  }

  @TestVisible
  private static Boolean triggerDisabledForSobject(
    OneGraph__TriggerToggle__c triggerToggles,
    String sobjectName,
    String triggerType
  ) {
    switch on sobjectName {
${triggerDisabledForSobject}
      when else {
        return false;
      }
    }
  }

  @namespaceAccessible
  public static Boolean shouldExecuteForTrigger(
    String sobjectName,
    String triggerType,
    String userId
  ) {
    OneGraph__TriggerToggle__c triggerToggles = OneGraph__TriggerToggle__c.getInstance(
      userId
    );

    if (triggerToggles.Disable_All_Triggers__c) {
      return false;
    }

    if (allDisabledForSobject(triggerToggles, sobjectName)) {
      return false;
    }

    if (triggerDisabledForSobject(triggerToggles, sobjectName, triggerType)) {
      return false;
    }

    return true;
  }
}`;

function main() {
  for (sobject of sobjects) {
    fs.writeFileSync(
      `package/main/default/objects/TriggerToggle__c/fields/${disableAllFileName(
        sobject,
      )}`,
      disableAllXmlBody(sobject),
    );
    for (trigger of triggers) {
      fs.writeFileSync(
        `package/main/default/objects/TriggerToggle__c/fields/${fileName(
          trigger,
          sobject,
        )}`,
        xmlBody(trigger, sobject),
      );
    }
  }
  fs.writeFileSync(
    'package/main/default/classes/OneGraphToggleSettingsTest.cls',
    toggleSettingsTestBody,
  );
  fs.writeFileSync(
    'package/main/default/classes/OneGraphToggleSettings.cls',
    toggleSettingsBody,
  );
}

if (require.main === module) {
  main();
}
