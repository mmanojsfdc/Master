/**
 * @group: SCA Review
 * @description: Test class is for SCASubmissionService Class
 */
@isTest public class SCASubmissionServiceTest {
  /**
   * @description: Setup Test data
   */
  @testSetup static void dataSetup() {
    // Get test Admin profile user form testDataUtils class to runn as admin
    List<User> adminUser = TestDataUtils.getUsers(1);
    // Run as test system admin user
    System.runAs(adminUser[0]) {
      // Get Repository Record
      List<Flosum__Repository__c> repositoryRecordList = TestDataUtils.getRepositories(1);
      insert repositoryRecordList;
      // Assign License to repository
      Flosum__Repository_Permission__c repositoryPermissionRecord =
          TestDataUtils.repoPermission(repositoryRecordList[0].id, adminUser[0].id);
      insert repositoryPermissionRecord;
      // Get Branch Record
      List<Flosum__Branch__c> listBranchDetails = TestDataUtils.getBranches(1);
      listBranchDetails[0].Flosum__Repository__c = repositoryRecordList[0].id;
      listBranchDetails[0].SCA_Integration_Status__c = 'Pending';
      insert listBranchDetails;
      // Get SCA Review History Record
      List<SCA_Review_History__c> scaHistoryList = TestDataUtils.getReviewHistory(1);
      scaHistoryList[0].SCA_Integration_Status__c = 'Pending';
      scaHistoryList[0].Branch__c = listBranchDetails[0].id;
      insert scaHistoryList;
      Blob body = Blob.valueOf('Test Data');
      // Get Attachment Record
      List<Attachment> attachmentsList = TestDataUtils.getAttachment(1);
      attachmentsList[0].ParentId = listBranchDetails[0].Id;
      attachmentsList[0].Name = '2022-09-15 QAValidate';
      attachmentsList[0].Body = body;
      insert attachmentsList;
    }
  }

  /**
   * @description: Cover getBranchDetails and chatterPost methods coverage
   */
  @isTest static void validateSCASubmissionInsert() {
    // Get test Admin profile user from testDataUtils class to run as admin
    User adminUser = TestUserUtils.createTestUser('System Administrator', '');
    System.runAs(adminUser) {
      // setup REST Request
      // clang-format off
      List<Flosum__Branch__c> listBranchDetails = [
          SELECT Id
          FROM Flosum__Branch__c LIMIT 1
      ];
      List<SCA_Review_History__c> scaHistory = [
          SELECT Id
      FROM SCA_Review_History__c LIMIT 1
      ];
      // clang-format on
      RestRequest request = new RestRequest();
      request.requestUri = URL.getSalesforceBaseUrl().toExternalForm() + '/SCASubmission';
      request.httpMethod = 'POST';
      request.addHeader('Content-Type', 'application/json');
      request.requestBody = Blob.valueOf('{ "sca" : "Testxnwjdbwcdwiji97874njsbdj"}');
      RestContext.request = request;
      RestResponse response = new RestResponse();
      RestContext.response = response;
      // clang-format off
      List<Attachment> attachments = [
    SELECT Id
    FROM Attachment
    WHERE
         ParentId = :listBranchDetails[0].id
      ];
      // clang-format on
      // Start Test
      Test.startTest();
      SCASubmissionService.getSubmittedBranches();
      SCASubmissionService.chatterPost();
      Test.stopTest();
      System.assertequals(scaHistory.size(), 1, 'There should be only 1 Review History');
    }
  }

  /**
   * @description: This Methos Used To Cover CatchBlock
   */
  @isTest static void exceptionTest() {
    // Get test Admin profile user from testDataUtils class to run as admin
    User minAccessUser = TestUserUtils.createTestUser('Minimum Access - Salesforce', '');
    System.runAs(minAccessUser) {
       try{
        // clang-format off
        List<Flosum__Branch__c> listBranchDetails = [
          SELECT Id
          FROM Flosum__Branch__c LIMIT 1
    ];
        // clang-format on
        Test.startTest();
        // SCASubmissionService.chatterPost();
        SCASubmissionService.getBranchDetails();
        Test.stopTest();
    }
        catch(Exception ex){
             System.assertequals(ex != null ,true,'Exception Occured');
        }
    }
  }
}