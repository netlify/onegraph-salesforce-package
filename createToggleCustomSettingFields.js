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
`;

const setAllForSobject = sobjects
  .map((sobject) => {
    return `      when '${sobject.toLowerCase()}' {
        triggerToggles.Disable_All_${sobject}_Triggers__c = value;
      }`;
  })
  .join('\n');

const setTriggerForSobject = sobjects
  .map((sobject) => {
    return `      when '${sobject.toLowerCase()}' {
        switch on triggerType {
          when 'insert' {
            triggerToggles.Disable_${sobject}_Insert_Trigger__c = value;
          }
          when 'update' {
            triggerToggles.Disable_${sobject}_Update_Trigger__c = value;
          }
          when 'delete' {
            triggerToggles.Disable_${sobject}_Delete_Trigger__c = value;
          }
          when 'undelete' {
            triggerToggles.Disable_${sobject}_Undelete_Trigger__c = value;
          }
        }
      }`;
  })
  .join('\n');

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

const setAllFieldsToDisabled = sobjects
  .map((sobject) => {
    return `    triggerToggles.Disable_${sobject}_Insert_Trigger__c = true;
    triggerToggles.Disable_${sobject}_Update_Trigger__c = true;
    triggerToggles.Disable_${sobject}_Delete_Trigger__c = true;
    triggerToggles.Disable_${sobject}_Undelete_Trigger__c = true;`;
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

  @namespaceAccessible
  public static Void initWithAllDisabled() {
    OneGraph__TriggerToggle__c triggerToggles = new OneGraph__TriggerToggle__c();
${setAllFieldsToDisabled}

    insert triggerToggles;
  }

  @namespaceAccessible
  public static void setAllForSobject(
    OneGraph__TriggerToggle__c triggerToggles,
    String sobjectName,
    Boolean value
  ) {
    switch on sobjectName {
${setAllForSobject}
    }
  }

  @namespaceAccessible
  public static void setTriggerForSobject(
    OneGraph__TriggerToggle__c triggerToggles,
    String sobjectName,
    String triggerType,
    Boolean value
  ) {
    switch on sobjectName {
${setTriggerForSobject}
    }
  }

  @namespaceAccessible
  public class SobjectSetting {
    public Boolean disableAll;
    public Boolean disableInsert;
    public Boolean disableUpdate;
    public Boolean disableDelete;
    public Boolean disableUndelete;

    public SobjectSetting(
      Boolean disableAll,
      Boolean disableInsert,
      Boolean disableUpdate,
      Boolean disableDelete,
      Boolean disableUndelete
    ) {
      this.disableAll = disableAll;
      this.disableInsert = disableInsert;
      this.disableUpdate = disableUpdate;
      this.disableDelete = disableDelete;
      this.disableUndelete = disableUndelete;
    }
  }

  @namespaceAccessible
  public class ToggleSettings {
    public Boolean disableAll;
    public Map<String, SobjectSetting> bySobjectName;

    public ToggleSettings(
      Boolean disableAll,
      Map<String, SobjectSetting> bySobjectName
    ) {
      this.disableAll = disableAll;
      this.bySobjectName = bySobjectName;
    }
  }

  @namespaceAccessible
  public static ToggleSettings getAllSettings(
    OneGraph__TriggerToggle__c triggerToggles
  ) {
    return new ToggleSettings(
      triggerToggles.Disable_All_Triggers__c,
      new Map<String, SobjectSetting>{
${sobjects
  .map(
    (sobject) =>
      `        '${sobject}' => new SobjectSetting(
          triggerToggles.Disable_All_${sobject}_Triggers__c,
          triggerToggles.Disable_${sobject}_Insert_Trigger__c,
          triggerToggles.Disable_${sobject}_Update_Trigger__c,
          triggerToggles.Disable_${sobject}_Delete_Trigger__c,
          triggerToggles.Disable_${sobject}_Undelete_Trigger__c
        )`,
  )
  .join(',\n')}
      }
    );
  }
}
`;

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
  console.warn(
    'Make sure SalesforceSubscriptionHelpers.supportsTriggerToggle has all sobjects',
  );
  console.warn(JSON.stringify(sobjects, null, 2));
  console.warn('Update the postinstall script to disable the new sobjects');
}

if (require.main === module) {
  main();
}
