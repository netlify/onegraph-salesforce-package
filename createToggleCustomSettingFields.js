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
  'CaseComment',
  'Case',
  'Contact',
  'Event',
  'FeedComment',
  'FeedItem',
  'Lead',
  'Opportunity',
  'Task',
];

const triggers = ['insert', 'update', 'delete', 'undelete'];

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
}

if (require.main === module) {
  main();
}
