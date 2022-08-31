@namespaceAccessible
public without sharing class OneGraphToggleSettings {
  @TestVisible
  private static Boolean allDisabledForSobject(
    OneGraph__TriggerToggle__c triggerToggles,
    String sobjectName
  ) {
    switch on sobjectName {
      when 'Account' {
        return triggerToggles.Disable_All_Account_Triggers__c;
      }
      when 'Case' {
        return triggerToggles.Disable_All_Case_Triggers__c;
      }
      when 'CaseComment' {
        return triggerToggles.Disable_All_CaseComment_Triggers__c;
      }
      when 'Contact' {
        return triggerToggles.Disable_All_Contact_Triggers__c;
      }
      when 'Event' {
        return triggerToggles.Disable_All_Event_Triggers__c;
      }
      when 'FeedComment' {
        return triggerToggles.Disable_All_FeedComment_Triggers__c;
      }
      when 'FeedItem' {
        return triggerToggles.Disable_All_FeedItem_Triggers__c;
      }
      when 'Lead' {
        return triggerToggles.Disable_All_Lead_Triggers__c;
      }
      when 'Opportunity' {
        return triggerToggles.Disable_All_Opportunity_Triggers__c;
      }
      when 'Task' {
        return triggerToggles.Disable_All_Task_Triggers__c;
      }
      when 'User' {
        return triggerToggles.Disable_All_User_Triggers__c;
      }
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
      when 'Account' {
        switch on triggerType {
          when 'insert' {
            return triggerToggles.Disable_Account_Insert_Trigger__c;
          }
          when 'update' {
            return triggerToggles.Disable_Account_Update_Trigger__c;
          }
          when 'delete' {
            return triggerToggles.Disable_Account_Delete_Trigger__c;
          }
          when 'undelete' {
            return triggerToggles.Disable_Account_Undelete_Trigger__c;
          }
          when else {
            return false;
          }
        }
      }
      when 'Case' {
        switch on triggerType {
          when 'insert' {
            return triggerToggles.Disable_Case_Insert_Trigger__c;
          }
          when 'update' {
            return triggerToggles.Disable_Case_Update_Trigger__c;
          }
          when 'delete' {
            return triggerToggles.Disable_Case_Delete_Trigger__c;
          }
          when 'undelete' {
            return triggerToggles.Disable_Case_Undelete_Trigger__c;
          }
          when else {
            return false;
          }
        }
      }
      when 'CaseComment' {
        switch on triggerType {
          when 'insert' {
            return triggerToggles.Disable_CaseComment_Insert_Trigger__c;
          }
          when 'update' {
            return triggerToggles.Disable_CaseComment_Update_Trigger__c;
          }
          when 'delete' {
            return triggerToggles.Disable_CaseComment_Delete_Trigger__c;
          }
          when 'undelete' {
            return triggerToggles.Disable_CaseComment_Undelete_Trigger__c;
          }
          when else {
            return false;
          }
        }
      }
      when 'Contact' {
        switch on triggerType {
          when 'insert' {
            return triggerToggles.Disable_Contact_Insert_Trigger__c;
          }
          when 'update' {
            return triggerToggles.Disable_Contact_Update_Trigger__c;
          }
          when 'delete' {
            return triggerToggles.Disable_Contact_Delete_Trigger__c;
          }
          when 'undelete' {
            return triggerToggles.Disable_Contact_Undelete_Trigger__c;
          }
          when else {
            return false;
          }
        }
      }
      when 'Event' {
        switch on triggerType {
          when 'insert' {
            return triggerToggles.Disable_Event_Insert_Trigger__c;
          }
          when 'update' {
            return triggerToggles.Disable_Event_Update_Trigger__c;
          }
          when 'delete' {
            return triggerToggles.Disable_Event_Delete_Trigger__c;
          }
          when 'undelete' {
            return triggerToggles.Disable_Event_Undelete_Trigger__c;
          }
          when else {
            return false;
          }
        }
      }
      when 'FeedComment' {
        switch on triggerType {
          when 'insert' {
            return triggerToggles.Disable_FeedComment_Insert_Trigger__c;
          }
          when 'update' {
            return triggerToggles.Disable_FeedComment_Update_Trigger__c;
          }
          when 'delete' {
            return triggerToggles.Disable_FeedComment_Delete_Trigger__c;
          }
          when 'undelete' {
            return triggerToggles.Disable_FeedComment_Undelete_Trigger__c;
          }
          when else {
            return false;
          }
        }
      }
      when 'FeedItem' {
        switch on triggerType {
          when 'insert' {
            return triggerToggles.Disable_FeedItem_Insert_Trigger__c;
          }
          when 'update' {
            return triggerToggles.Disable_FeedItem_Update_Trigger__c;
          }
          when 'delete' {
            return triggerToggles.Disable_FeedItem_Delete_Trigger__c;
          }
          when 'undelete' {
            return triggerToggles.Disable_FeedItem_Undelete_Trigger__c;
          }
          when else {
            return false;
          }
        }
      }
      when 'Lead' {
        switch on triggerType {
          when 'insert' {
            return triggerToggles.Disable_Lead_Insert_Trigger__c;
          }
          when 'update' {
            return triggerToggles.Disable_Lead_Update_Trigger__c;
          }
          when 'delete' {
            return triggerToggles.Disable_Lead_Delete_Trigger__c;
          }
          when 'undelete' {
            return triggerToggles.Disable_Lead_Undelete_Trigger__c;
          }
          when else {
            return false;
          }
        }
      }
      when 'Opportunity' {
        switch on triggerType {
          when 'insert' {
            return triggerToggles.Disable_Opportunity_Insert_Trigger__c;
          }
          when 'update' {
            return triggerToggles.Disable_Opportunity_Update_Trigger__c;
          }
          when 'delete' {
            return triggerToggles.Disable_Opportunity_Delete_Trigger__c;
          }
          when 'undelete' {
            return triggerToggles.Disable_Opportunity_Undelete_Trigger__c;
          }
          when else {
            return false;
          }
        }
      }
      when 'Task' {
        switch on triggerType {
          when 'insert' {
            return triggerToggles.Disable_Task_Insert_Trigger__c;
          }
          when 'update' {
            return triggerToggles.Disable_Task_Update_Trigger__c;
          }
          when 'delete' {
            return triggerToggles.Disable_Task_Delete_Trigger__c;
          }
          when 'undelete' {
            return triggerToggles.Disable_Task_Undelete_Trigger__c;
          }
          when else {
            return false;
          }
        }
      }
      when 'User' {
        switch on triggerType {
          when 'insert' {
            return triggerToggles.Disable_User_Insert_Trigger__c;
          }
          when 'update' {
            return triggerToggles.Disable_User_Update_Trigger__c;
          }
          when 'delete' {
            return triggerToggles.Disable_User_Delete_Trigger__c;
          }
          when 'undelete' {
            return triggerToggles.Disable_User_Undelete_Trigger__c;
          }
          when else {
            return false;
          }
        }
      }
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
    triggerToggles.Disable_Account_Insert_Trigger__c = true;
    triggerToggles.Disable_Account_Update_Trigger__c = true;
    triggerToggles.Disable_Account_Delete_Trigger__c = true;
    triggerToggles.Disable_Account_Undelete_Trigger__c = true;
    triggerToggles.Disable_Case_Insert_Trigger__c = true;
    triggerToggles.Disable_Case_Update_Trigger__c = true;
    triggerToggles.Disable_Case_Delete_Trigger__c = true;
    triggerToggles.Disable_Case_Undelete_Trigger__c = true;
    triggerToggles.Disable_CaseComment_Insert_Trigger__c = true;
    triggerToggles.Disable_CaseComment_Update_Trigger__c = true;
    triggerToggles.Disable_CaseComment_Delete_Trigger__c = true;
    triggerToggles.Disable_CaseComment_Undelete_Trigger__c = true;
    triggerToggles.Disable_Contact_Insert_Trigger__c = true;
    triggerToggles.Disable_Contact_Update_Trigger__c = true;
    triggerToggles.Disable_Contact_Delete_Trigger__c = true;
    triggerToggles.Disable_Contact_Undelete_Trigger__c = true;
    triggerToggles.Disable_Event_Insert_Trigger__c = true;
    triggerToggles.Disable_Event_Update_Trigger__c = true;
    triggerToggles.Disable_Event_Delete_Trigger__c = true;
    triggerToggles.Disable_Event_Undelete_Trigger__c = true;
    triggerToggles.Disable_FeedComment_Insert_Trigger__c = true;
    triggerToggles.Disable_FeedComment_Update_Trigger__c = true;
    triggerToggles.Disable_FeedComment_Delete_Trigger__c = true;
    triggerToggles.Disable_FeedComment_Undelete_Trigger__c = true;
    triggerToggles.Disable_FeedItem_Insert_Trigger__c = true;
    triggerToggles.Disable_FeedItem_Update_Trigger__c = true;
    triggerToggles.Disable_FeedItem_Delete_Trigger__c = true;
    triggerToggles.Disable_FeedItem_Undelete_Trigger__c = true;
    triggerToggles.Disable_Lead_Insert_Trigger__c = true;
    triggerToggles.Disable_Lead_Update_Trigger__c = true;
    triggerToggles.Disable_Lead_Delete_Trigger__c = true;
    triggerToggles.Disable_Lead_Undelete_Trigger__c = true;
    triggerToggles.Disable_Opportunity_Insert_Trigger__c = true;
    triggerToggles.Disable_Opportunity_Update_Trigger__c = true;
    triggerToggles.Disable_Opportunity_Delete_Trigger__c = true;
    triggerToggles.Disable_Opportunity_Undelete_Trigger__c = true;
    triggerToggles.Disable_Task_Insert_Trigger__c = true;
    triggerToggles.Disable_Task_Update_Trigger__c = true;
    triggerToggles.Disable_Task_Delete_Trigger__c = true;
    triggerToggles.Disable_Task_Undelete_Trigger__c = true;
    triggerToggles.Disable_User_Insert_Trigger__c = true;
    triggerToggles.Disable_User_Update_Trigger__c = true;
    triggerToggles.Disable_User_Delete_Trigger__c = true;
    triggerToggles.Disable_User_Undelete_Trigger__c = true;

    insert triggerToggles;
  }

  @namespaceAccessible
  public static void setAllForSobject(
    OneGraph__TriggerToggle__c triggerToggles,
    String sobjectName,
    Boolean value
  ) {
    switch on sobjectName {
      when 'account' {
        triggerToggles.Disable_All_Account_Triggers__c = value;
      }
      when 'case' {
        triggerToggles.Disable_All_Case_Triggers__c = value;
      }
      when 'casecomment' {
        triggerToggles.Disable_All_CaseComment_Triggers__c = value;
      }
      when 'contact' {
        triggerToggles.Disable_All_Contact_Triggers__c = value;
      }
      when 'event' {
        triggerToggles.Disable_All_Event_Triggers__c = value;
      }
      when 'feedcomment' {
        triggerToggles.Disable_All_FeedComment_Triggers__c = value;
      }
      when 'feeditem' {
        triggerToggles.Disable_All_FeedItem_Triggers__c = value;
      }
      when 'lead' {
        triggerToggles.Disable_All_Lead_Triggers__c = value;
      }
      when 'opportunity' {
        triggerToggles.Disable_All_Opportunity_Triggers__c = value;
      }
      when 'task' {
        triggerToggles.Disable_All_Task_Triggers__c = value;
      }
      when 'user' {
        triggerToggles.Disable_All_User_Triggers__c = value;
      }
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
      when 'account' {
        switch on triggerType {
          when 'insert' {
            triggerToggles.Disable_Account_Insert_Trigger__c = value;
          }
          when 'update' {
            triggerToggles.Disable_Account_Update_Trigger__c = value;
          }
          when 'delete' {
            triggerToggles.Disable_Account_Delete_Trigger__c = value;
          }
          when 'undelete' {
            triggerToggles.Disable_Account_Undelete_Trigger__c = value;
          }
        }
      }
      when 'case' {
        switch on triggerType {
          when 'insert' {
            triggerToggles.Disable_Case_Insert_Trigger__c = value;
          }
          when 'update' {
            triggerToggles.Disable_Case_Update_Trigger__c = value;
          }
          when 'delete' {
            triggerToggles.Disable_Case_Delete_Trigger__c = value;
          }
          when 'undelete' {
            triggerToggles.Disable_Case_Undelete_Trigger__c = value;
          }
        }
      }
      when 'casecomment' {
        switch on triggerType {
          when 'insert' {
            triggerToggles.Disable_CaseComment_Insert_Trigger__c = value;
          }
          when 'update' {
            triggerToggles.Disable_CaseComment_Update_Trigger__c = value;
          }
          when 'delete' {
            triggerToggles.Disable_CaseComment_Delete_Trigger__c = value;
          }
          when 'undelete' {
            triggerToggles.Disable_CaseComment_Undelete_Trigger__c = value;
          }
        }
      }
      when 'contact' {
        switch on triggerType {
          when 'insert' {
            triggerToggles.Disable_Contact_Insert_Trigger__c = value;
          }
          when 'update' {
            triggerToggles.Disable_Contact_Update_Trigger__c = value;
          }
          when 'delete' {
            triggerToggles.Disable_Contact_Delete_Trigger__c = value;
          }
          when 'undelete' {
            triggerToggles.Disable_Contact_Undelete_Trigger__c = value;
          }
        }
      }
      when 'event' {
        switch on triggerType {
          when 'insert' {
            triggerToggles.Disable_Event_Insert_Trigger__c = value;
          }
          when 'update' {
            triggerToggles.Disable_Event_Update_Trigger__c = value;
          }
          when 'delete' {
            triggerToggles.Disable_Event_Delete_Trigger__c = value;
          }
          when 'undelete' {
            triggerToggles.Disable_Event_Undelete_Trigger__c = value;
          }
        }
      }
      when 'feedcomment' {
        switch on triggerType {
          when 'insert' {
            triggerToggles.Disable_FeedComment_Insert_Trigger__c = value;
          }
          when 'update' {
            triggerToggles.Disable_FeedComment_Update_Trigger__c = value;
          }
          when 'delete' {
            triggerToggles.Disable_FeedComment_Delete_Trigger__c = value;
          }
          when 'undelete' {
            triggerToggles.Disable_FeedComment_Undelete_Trigger__c = value;
          }
        }
      }
      when 'feeditem' {
        switch on triggerType {
          when 'insert' {
            triggerToggles.Disable_FeedItem_Insert_Trigger__c = value;
          }
          when 'update' {
            triggerToggles.Disable_FeedItem_Update_Trigger__c = value;
          }
          when 'delete' {
            triggerToggles.Disable_FeedItem_Delete_Trigger__c = value;
          }
          when 'undelete' {
            triggerToggles.Disable_FeedItem_Undelete_Trigger__c = value;
          }
        }
      }
      when 'lead' {
        switch on triggerType {
          when 'insert' {
            triggerToggles.Disable_Lead_Insert_Trigger__c = value;
          }
          when 'update' {
            triggerToggles.Disable_Lead_Update_Trigger__c = value;
          }
          when 'delete' {
            triggerToggles.Disable_Lead_Delete_Trigger__c = value;
          }
          when 'undelete' {
            triggerToggles.Disable_Lead_Undelete_Trigger__c = value;
          }
        }
      }
      when 'opportunity' {
        switch on triggerType {
          when 'insert' {
            triggerToggles.Disable_Opportunity_Insert_Trigger__c = value;
          }
          when 'update' {
            triggerToggles.Disable_Opportunity_Update_Trigger__c = value;
          }
          when 'delete' {
            triggerToggles.Disable_Opportunity_Delete_Trigger__c = value;
          }
          when 'undelete' {
            triggerToggles.Disable_Opportunity_Undelete_Trigger__c = value;
          }
        }
      }
      when 'task' {
        switch on triggerType {
          when 'insert' {
            triggerToggles.Disable_Task_Insert_Trigger__c = value;
          }
          when 'update' {
            triggerToggles.Disable_Task_Update_Trigger__c = value;
          }
          when 'delete' {
            triggerToggles.Disable_Task_Delete_Trigger__c = value;
          }
          when 'undelete' {
            triggerToggles.Disable_Task_Undelete_Trigger__c = value;
          }
        }
      }
      when 'user' {
        switch on triggerType {
          when 'insert' {
            triggerToggles.Disable_User_Insert_Trigger__c = value;
          }
          when 'update' {
            triggerToggles.Disable_User_Update_Trigger__c = value;
          }
          when 'delete' {
            triggerToggles.Disable_User_Delete_Trigger__c = value;
          }
          when 'undelete' {
            triggerToggles.Disable_User_Undelete_Trigger__c = value;
          }
        }
      }
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
        'Account' => new SobjectSetting(
          triggerToggles.Disable_All_Account_Triggers__c,
          triggerToggles.Disable_Account_Insert_Trigger__c,
          triggerToggles.Disable_Account_Update_Trigger__c,
          triggerToggles.Disable_Account_Delete_Trigger__c,
          triggerToggles.Disable_Account_Undelete_Trigger__c
        ),
        'Case' => new SobjectSetting(
          triggerToggles.Disable_All_Case_Triggers__c,
          triggerToggles.Disable_Case_Insert_Trigger__c,
          triggerToggles.Disable_Case_Update_Trigger__c,
          triggerToggles.Disable_Case_Delete_Trigger__c,
          triggerToggles.Disable_Case_Undelete_Trigger__c
        ),
        'CaseComment' => new SobjectSetting(
          triggerToggles.Disable_All_CaseComment_Triggers__c,
          triggerToggles.Disable_CaseComment_Insert_Trigger__c,
          triggerToggles.Disable_CaseComment_Update_Trigger__c,
          triggerToggles.Disable_CaseComment_Delete_Trigger__c,
          triggerToggles.Disable_CaseComment_Undelete_Trigger__c
        ),
        'Contact' => new SobjectSetting(
          triggerToggles.Disable_All_Contact_Triggers__c,
          triggerToggles.Disable_Contact_Insert_Trigger__c,
          triggerToggles.Disable_Contact_Update_Trigger__c,
          triggerToggles.Disable_Contact_Delete_Trigger__c,
          triggerToggles.Disable_Contact_Undelete_Trigger__c
        ),
        'Event' => new SobjectSetting(
          triggerToggles.Disable_All_Event_Triggers__c,
          triggerToggles.Disable_Event_Insert_Trigger__c,
          triggerToggles.Disable_Event_Update_Trigger__c,
          triggerToggles.Disable_Event_Delete_Trigger__c,
          triggerToggles.Disable_Event_Undelete_Trigger__c
        ),
        'FeedComment' => new SobjectSetting(
          triggerToggles.Disable_All_FeedComment_Triggers__c,
          triggerToggles.Disable_FeedComment_Insert_Trigger__c,
          triggerToggles.Disable_FeedComment_Update_Trigger__c,
          triggerToggles.Disable_FeedComment_Delete_Trigger__c,
          triggerToggles.Disable_FeedComment_Undelete_Trigger__c
        ),
        'FeedItem' => new SobjectSetting(
          triggerToggles.Disable_All_FeedItem_Triggers__c,
          triggerToggles.Disable_FeedItem_Insert_Trigger__c,
          triggerToggles.Disable_FeedItem_Update_Trigger__c,
          triggerToggles.Disable_FeedItem_Delete_Trigger__c,
          triggerToggles.Disable_FeedItem_Undelete_Trigger__c
        ),
        'Lead' => new SobjectSetting(
          triggerToggles.Disable_All_Lead_Triggers__c,
          triggerToggles.Disable_Lead_Insert_Trigger__c,
          triggerToggles.Disable_Lead_Update_Trigger__c,
          triggerToggles.Disable_Lead_Delete_Trigger__c,
          triggerToggles.Disable_Lead_Undelete_Trigger__c
        ),
        'Opportunity' => new SobjectSetting(
          triggerToggles.Disable_All_Opportunity_Triggers__c,
          triggerToggles.Disable_Opportunity_Insert_Trigger__c,
          triggerToggles.Disable_Opportunity_Update_Trigger__c,
          triggerToggles.Disable_Opportunity_Delete_Trigger__c,
          triggerToggles.Disable_Opportunity_Undelete_Trigger__c
        ),
        'Task' => new SobjectSetting(
          triggerToggles.Disable_All_Task_Triggers__c,
          triggerToggles.Disable_Task_Insert_Trigger__c,
          triggerToggles.Disable_Task_Update_Trigger__c,
          triggerToggles.Disable_Task_Delete_Trigger__c,
          triggerToggles.Disable_Task_Undelete_Trigger__c
        ),
        'User' => new SobjectSetting(
          triggerToggles.Disable_All_User_Triggers__c,
          triggerToggles.Disable_User_Insert_Trigger__c,
          triggerToggles.Disable_User_Update_Trigger__c,
          triggerToggles.Disable_User_Delete_Trigger__c,
          triggerToggles.Disable_User_Undelete_Trigger__c
        )
      }
    );
  }
}
