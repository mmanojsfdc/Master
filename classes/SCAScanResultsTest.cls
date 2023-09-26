/**
 * @group:SCA Review
 * @description: Test class is for SCAScanResults Class
 */
@isTest public class SCAScanResultsTest {
  /**
   * @description: Setup Test data
   */
  @testSetup static void dataSetup() {
    // Get test Admin profile user form testDataUtils class to runn as admin
    List<User> adminUser = TestDataUtils.getUsers(1);
    // Run as test system admin user
    System.runAs(adminUser[0]) {
      // Create Repository record
      List<Flosum__Repository__c> repositoryRecordList = TestDataUtils.getRepositories(1);
      insert repositoryRecordList;
      // Assign License to repository
      Flosum__Repository_Permission__c repositoryPermissionRecord =
          TestDataUtils.repoPermission(repositoryRecordList[0].id, adminUser[0].id);
      insert repositoryPermissionRecord;
      // Create a Branch Record
      List<Flosum__Branch__c> listBranchDetails = TestDataUtils.getBranches(1);
      listBranchDetails[0].Flosum__Repository__c = repositoryRecordList[0].id;
      listBranchDetails[0].Has_Apex_Code__c = False;
      insert listBranchDetails;
      // Create ReviewHistory Record
      List<SCA_Review_History__c> listOfReviewHistory = TestDataUtils.getReviewHistory(1);
      // listOfReviewHistory[0].SCA_Integration_Status__c = 'Success';
      listOfReviewHistory[0].Branch__c = listBranchDetails[0].Id;
      insert listOfReviewHistory;
      // Create SCA Result Record
      List<SCA_Result__c> scaResultList = new List<SCA_Result__c>();
      SCA_Result__c sca = new SCA_Result__c();
      sca.SCA_Review_History__c = listOfReviewHistory[0].Id;
      scaResultList.add(sca);
      insert scaResultList;
      // Create a ViolationRecord Record
      List<SCA_Violations__c> listViolationRecord = TestDataUtils.getViolationRecords(1);
      listViolationRecord[0].SCA_Result__c = scaResultList[0].id;
    }
  }

  /**
   * @description: Cover recordCreation and chatterPost methods coverage
   */
  @isTest static void recordCreationTest() {
    // Get test Admin profile user from testDataUtils class to run as admin
    User adminUser = TestUserUtils.createTestUser('System Administrator', '');
    String scaReviewHistory;
    string contents =
        'Action.cls,3,1,Avoid using global modifier,Best Practices,AvoidGlobalModifier!%!Action.cls,3,1,Missing ApexDoc comment,Documentation,ApexDoc!%!Action.cls,3,2,Avoid empty block statements.,Error Prone,EmptyStatementBlock!%!Action.cls,3,2,Missing ApexDoc comment,Documentation,ApexDoc!%!Action.cls,3,3,Avoid empty block statements.,Error Prone,EmptyStatementBlock';
    String message = 'Test';
    system.runAs(adminUser) {
      // clang-format off
      List<SCA_Review_History__c> scaHistory = [
          SELECT Id
		  FROM SCA_Review_History__c LIMIT 1
      ];
      // clang-format on
      scaReviewHistory = scaHistory[0].Id;
      // clang-format off
      List<SCA_Violations__c> scaViolation = [
          SELECT Id
          FROM SCA_Violations__c LIMIT 1
      ];
      // clang-format on
      SCAScanResults.chatterPost(scaHistory[0].Id, message);
      SCAScanResults.recordCreation(scaReviewHistory, contents);
      System.assertequals(scaHistory.size(), 1, 'There should be only 1 Review History');
    }
  }

  /**
   * @description: Cover catch block coverage
   */
  @isTest static void recordCreationExceptionTest() {
    // Get test Admin profile user from testDataUtils class to run as admin
    User adminUser = TestUserUtils.createTestUser('System Administrator', '');
    String scaReviewHistory;
    string contents =
        'Action.cls,3,1,Avoid using global modifier,Best Practices,AvoidGlobalModifier!%!Action.cls,CatchBlockCoverage,1,Missing ApexDoc comment,Documentation,ApexDoc!%!Action.cls,3,2,Avoid empty block statements.,Error Prone,EmptyStatementBlock!%!Action.cls,3,2,Missing ApexDoc comment,Documentation,ApexDoc!%!Action.cls,3,3,Avoid empty block statements.,Error Prone,EmptyStatementBlock';
    String message = 'Test';
    system.runAs(adminUser) {
      // clang-format off
      List<SCA_Review_History__c> scaHistory = [
          SELECT Id
          FROM SCA_Review_History__c LIMIT 1
      ];
      // clang-format on
      scaReviewHistory = scaHistory[0].Id;
      // clang-format off
      List<SCA_Violations__c> scaViolation = [
          SELECT Id
          FROM SCA_Violations__c LIMIT 1
      ];
      // clang-format on
      SCAScanResults.chatterPost(scaHistory[0].Id, message);
      SCAScanResults.recordCreation(scaReviewHistory, contents);
      System.assertequals(scaHistory.size(), 1, 'There should be only 1 Review History');
    }
  }
}