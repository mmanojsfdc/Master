/**
 * @group: ComponentService
 * @description: Test class is for ComponentTriggerService Class
 */
@isTest public class ComponentTriggerServiceTest {
  /**
   * @description: Setup Test data
   */
  @testSetup static void dataSetup() {
    // Get test Admin profile user form testDataUtils class to runn as admin
    List<User> adminUser = TestDataUtils.getUsers(1);
    // Run as system admin user
    System.runAs(adminUser[0]) {
      // Create Repository
      List<Flosum__Repository__c> repositoryRecordList = TestDataUtils.getRepositories(1);
      insert repositoryRecordList;
      // Assign License to repository
      Flosum__Repository_Permission__c repositoryPermissionRecord =
          TestDataUtils.repoPermission(repositoryRecordList[0].id, adminUser[0].id);
      insert repositoryPermissionRecord;
      // Create a Branch Record
      List<Flosum__Branch__c> listBranchDetails = TestDataUtils.getBranches(4);
      listBranchDetails[0].Flosum__Repository__c = repositoryRecordList[0].id;
      listBranchDetails[0].Has_Apex_Code__c = False;
      listBranchDetails[1].Flosum__Repository__c = repositoryRecordList[0].id;
      listBranchDetails[1].Has_Apex_Code__c = False;
      listBranchDetails[2].Flosum__Repository__c = repositoryRecordList[0].id;
      listBranchDetails[2].Has_Apex_Code__c = True;
      listBranchDetails[2].Is_SCA_Passed__c = True;
      listBranchDetails[2].Code_Coverage_Met__c = True;
      listBranchDetails[3].Flosum__Repository__c = repositoryRecordList[0].id;
      listBranchDetails[3].Has_Apex_Code__c = True;
      insert listBranchDetails;
      // Create Components and attach it to Branch
      List<Flosum__Component__c> branchComponentList = new List<Flosum__Component__c>();
      branchComponentList.addAll(TestDataUtils.getComponents(1, 'ApexClass'));
      branchComponentList.addAll(TestDataUtils.getComponents(1, 'ApexTrigger'));
      branchComponentList.addAll(TestDataUtils.getComponents(1, 'Flow'));
      for (integer i = 0; i < branchComponentList.size(); i++) {
        branchComponentList[i].Flosum__Branch__c = listBranchDetails[2].id;
      }
      insert branchComponentList;
    }  // end of run as System Admin
  }    // End of dataSetup

  /**
   * @description: Cover checkHasApexCodeBasedOnComponentType method coverage
   */
  @isTest static void checkHasApexCodeBasedOnComponentTypeTest() {
    // clang-format off
      User adminUser = [
        SELECT id, Name
        FROM User
        LIMIT 1
    ];
    // clang-format on
    // Run as test system admin user
    System.runAs(adminUser) {
      // clang-format off
      List<Flosum__Branch__c> branchDetailsList = [
          SELECT id, Name, Has_Apex_Code__c
 		  FROM Flosum__Branch__c
          WHERE
           Has_Apex_Code__c = False];
      // clang-format on
      List<Flosum__Component__c> branchComponentList = TestDataUtils.getComponents(1, 'ApexClass');
      branchComponentList.addAll(TestDataUtils.getComponents(1, 'Flow'));
      branchComponentList.addAll(TestDataUtils.getComponents(1, 'ApexTrigger'));
      for (integer i = 0; i < branchComponentList.size(); i++) {
        branchComponentList[i].Flosum__Branch__c = branchDetailsList[0].id;
      }
      Test.startTest();
      insert branchComponentList;
      // Update to Cover the Update method in ComponentTriggerHandler
      branchComponentList[0].Flosum__Comments__c = 'Sample Comment';
      update branchComponentList;
      Test.stopTest();
      System.assertEquals(branchComponentList.size(), 3, 'There should be 3 components');
    }
  }

  /**
   * @description: Cover uncheckHasApexCodeBasedOnComponentType method coverage
   */
  @isTest static void uncheckHasApexCodeBasedOnComponentTypeTest() {
    // clang-format off
    User adminUser = [
        SELECT id, Name
        FROM User
        LIMIT 1
    ];
    // clang-format on
    // Run as test system admin user
    System.runAs(adminUser) {
      // clang-format off
      List<Flosum__Component__c> branchComponenttoDeleteList = [
          SELECT id, Name, Flosum__Component_Type__c
          FROM Flosum__Component__c
      ];
      // clang-format on
      Test.startTest();
      delete branchComponenttoDeleteList;
      // undelete to Cover the Update method in ComponentTriggerHandler
      undelete branchComponenttoDeleteList;
      Test.stopTest();
      System.assertEquals(branchComponenttoDeleteList.size(), 3, 'There should be 3 components');
    }  // end of run as System Admin
  }    // end ofuncheckHasApexCodeBasedOnComponentTypeTest

  /**
   * @description: Cover uncheckHasApexCodeBasedOnComponentType method coverage with removal of
   * single Component record
   */
  @isTest static void unchangeHasApexCodeBasedOnComponentTypeTest() {
    User adminUser = [SELECT id, Name FROM User LIMIT 1];
    // Run as test system admin user
    System.runAs(adminUser) {
      // clang-format off
      List<Flosum__Component__c> branchComponenttoDeleteList = [
          SELECT id, Name, Flosum__Component_Type__c
		  FROM Flosum__Component__c
          WHERE
           Flosum__Component_Type__c ='ApexClass'
      ];
      // clang-format on
      Test.startTest();
      delete branchComponenttoDeleteList;
      Test.stopTest();
      System.assertEquals(
          branchComponenttoDeleteList.size(), 1, 'There should only be 1 components');
    }  // end of run as System Admin
  }    // end ofuncheckHasApexCodeBasedOnComponentTypeTest

  /**
   * @description: Cover uncheckIsSCAPassedAndCodeCoverageMet method coverage with removal of
   * single Component record
   */
  @isTest static void uncheckIsSCAPassedAndCodeCoverageMetTest() {
    // clang-format off
    User adminUser = [
        SELECT id, Name
        FROM User
        LIMIT 1
    ];
    // clang-format on
    // Run as test system admin user
    System.runAs(adminUser) {
      // clang-format off
      List<Flosum__Component__c> branchComponenttoDeleteList = [
          SELECT id, Name, Flosum__Component_Type__c
		  FROM Flosum__Component__c
          WHERE
           Flosum__Component_Type__c ='ApexClass'
      ];
	  List<Flosum__Branch__c> branchDetailsList = [
          SELECT id, Name, Has_Apex_Code__c,Is_SCA_Passed__c,Code_Coverage_Met__c
		  FROM Flosum__Branch__c
          WHERE
           Code_Coverage_Met__c = TRUE
           OR Is_SCA_Passed__c = TRUE
      ];
      // clang-format on
      for (Flosum__Branch__c branch : branchDetailsList) {
        branch.Code_Coverage_Met__c = False;
        branch.Is_SCA_Passed__c = False;
      }
      Test.startTest();
      delete branchComponenttoDeleteList;
      update branchDetailsList;
      Test.stopTest();
      System.assertEquals(
          branchComponenttoDeleteList.size(), 1, 'There should only be 1 components');
    }  // end of run as System Admin
  }    // end uncheckIsSCAPassedAndCodeCoverageMet
}