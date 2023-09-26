/**
 * @group: ComponentService
 * @description: This class is for handling Component trigger methods
 */
public
with sharing class ComponentTriggerService {
  static final string APEX_CLASS = 'ApexClass';
  static final string APEX_TRIGGER = 'ApexTrigger';
  private
  static ComponentTriggerService instance = null;

  /**
   * @description: Use this method to get an instance instead of constructor
   * @return: singleton instance of CaseTriggerService
   */
  public
  static ComponentTriggerService getInstance() {
    if (instance == null) {
      instance = new ComponentTriggerService();
    }
    return instance;
  }  // End of getInstance

  /**
   * @description: Update Branch Record Has Apex Code Checkbox to True based on Component Type
   * @param: newMap
   */
  public
  void checkHasApexCodeBasedOnComponentType(Map<Id, sObject> newMap) {
    Map<Id, Flosum__Component__c> newComponentMap = (Map<Id, Flosum__Component__c>) newMap;
    List<Id> listOfBranchIds = new List<Id>();
    List<Flosum__Branch__c> listBranchDetails = new List<Flosum__Branch__c>();
    for (Flosum__Component__c eachComponent : newComponentMap.values()) {
      if (eachComponent.Flosum__Branch__c != null
          && (eachComponent.Flosum__Component_Type__c.contains(APEX_CLASS)
              || eachComponent.Flosum__Component_Type__c.contains(APEX_TRIGGER))) {
        listOfBranchIds.add(eachComponent.Flosum__Branch__c);
      } else {
        continue;
      }
    }
    // clang-format off
      for (Flosum__Branch__c eachBranch : [
          SELECT id, Name, Has_Apex_Code__c,Is_SCA_Passed__c
          FROM Flosum__Branch__c
          WHERE
           id IN:listOfBranchIds
           AND Has_Apex_Code__c = False
          WITH SECURITY_ENFORCED
      ])
    // clang-format on
    {
      eachBranch.Has_Apex_Code__c = True;
      eachBranch.Is_SCA_Passed__c = False;
      eachBranch.Code_Coverage_Met__c = False;
      listBranchDetails.add(eachBranch);
    }
    if (listBranchDetails.size() > 0 && Schema.sObjectType.Flosum__Branch__c.isUpdateable()) {
      Update listBranchDetails;
    }
  }

  /**
   * @description: update Branch Record field Has Apex Code Checkbox to False based on Component
   * Type
   * @param: oldMap
   */
  public
  void uncheckHasApexCodeBasedOnComponentType(Map<Id, sObject> oldMap) {
    // It should be OLD MAP in case of Deletion**
    Map<Id, Flosum__Component__c> oldComponentMap = (Map<Id, Flosum__Component__c>) oldMap;
    List<Flosum__Component__c> listOfComponents = new List<Flosum__Component__C>();
    List<Flosum__Branch__c> listOfBranchDetails = new List<Flosum__Branch__c>();
    set<id> setOfBranchIds = new set<id>();
    // Get the Branch Record Id
    for (Flosum__Component__c eachComponent : oldComponentMap.values()) {
      if (eachComponent.Flosum__Branch__c != null) {
        // Store the Branch Record Ids
        setOfBranchIds.add(eachComponent.Flosum__Branch__c);
      }
    }
    // Iterate over Branch Records where branch id IN setOfBranchIds and ComponentType is not
    // ApexClass or ApexTrigger
    // clang-format off
      for (Flosum__Branch__c eachBranch : [
          SELECT Id,Name,Has_Apex_Code__c,Is_SCA_Passed__c,
           (SELECT id,Name,Flosum__Component_Type__c
            FROM Flosum__Components__r
            WHERE
             Flosum__Component_Type__c =: APEX_CLASS
             OR Flosum__Component_Type__c =: APEX_TRIGGER)
          FROM Flosum__Branch__c
          WHERE
           Has_Apex_Code__c = True
           AND id IN:setOfBranchIds
          WITH SECURITY_ENFORCED
      ])
    // clang-format on
    {
      if (eachBranch.Flosum__Components__r.isempty()) {
        eachBranch.Has_Apex_Code__c = False;
        eachBranch.Is_SCA_Passed__c = False;
        listOfBranchDetails.add(eachBranch);
      } else {
        Continue;
      }
    }
    if (listOfBranchDetails.size() > 0 && Schema.sObjectType.Flosum__Branch__c.isUpdateable()) {
      update listOfBranchDetails;
    }
  }

  /**
   * @description: Update Branch Record Is SCA Passed and Code Coverage met if any component has
   * been removed
   * @param: newMap
   */
  public
  void uncheckIsSCAPassedAndCodeCoverageMet(Map<Id, sObject> oldMap) {
    // It should be OLD MAP in case of Deletion**
    Map<Id, Flosum__Component__c> oldComponentMap = (Map<Id, Flosum__Component__c>) oldMap;
    List<Flosum__Component__c> listOfComponents = new List<Flosum__Component__C>();
    List<Flosum__Branch__c> listOfBranchDetails = new List<Flosum__Branch__c>();
    set<id> setOfBranchIds = new set<id>();
    // Get the Branch Record Id
    for (Flosum__Component__c eachComponent : oldComponentMap.values()) {
      if (eachComponent.Flosum__Branch__c != null) {
        // Store the Branch Record Ids
        setOfBranchIds.add(eachComponent.Flosum__Branch__c);
      }
    }
    // Iterate over Branch Records where branch id IN setOfBranchIds
    // clang-format off
    for (Flosum__Branch__c eachBranch : [
         SELECT Id, Name, Has_Apex_Code__c, Is_SCA_Passed__c, Code_Coverage_Met__c
         FROM Flosum__Branch__c
         WHERE
          Has_Apex_Code__c = True
          AND (Is_SCA_Passed__c = True
	       OR Code_Coverage_Met__c= True)
		  AND id IN:setOfBranchIds
         WITH SECURITY_ENFORCED
	  ])
    // clang-format on
    {
      eachBranch.Is_SCA_Passed__c = False;
      eachBranch.Code_Coverage_Met__c = False;
      listOfBranchDetails.add(eachBranch);
    }
    if (listOfBranchDetails.size() > 0 && Schema.sObjectType.Flosum__Branch__c.isUpdateable()) {
      update listOfBranchDetails;
    }
  }
}