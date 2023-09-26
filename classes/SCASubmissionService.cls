/**
 * @group: SCA Review
 * @description: Webservice class to submit branches for SCA review
 * @testclass: SCASubmissionServiceTest
 */
@RestResource(urlMapping = '/SCASubmission/*') global with sharing class SCASubmissionService {
  private
  static final String REVIEW_STATUS_QUEUED = 'Queued';
  private
  static final String REVIEW_STATUS_PENDING = 'Pending';
  private
  static final string BRANCH_SCA_ENQUED_MESSAGE = LABEL.BRANCH_SCA_ENQUED;
  private
  static final String SCA_REVIEW_EDIT_ERROR = LABEL.NO_EDIT_ACCESS_ON_SCA_REVIEW_HISTORY;
  private
  static List<SCA_Review_History__c> scaHistoryDetailList = new List<SCA_Review_History__c>();
  private
  static Set<Id> branchIdsSet = new Set<Id>();

  /**
   * @description: Queries branches which are submitted for SCA Review
   **/
  @HttpGet global static void getSubmittedBranches() {
    RestResponse resp = RestContext.response;
    resp.statusCode = 200;
    // Creating response
    String responseBody = getBranchDetails();
    resp.responseBody = Blob.valueOf(responseBody);
  }

  /**
   * @description: Queries branches which are submitted for SCA Review
   *and fetches SCA Review History Record.
   * @return String: Branches with SCA Review History record and Attachment Details
   **/
  global static String getBranchDetails() {
    List<Flosum__Branch__c> branchDetailsList = new List<Flosum__Branch__c>();
    ServiceResponse response = new ServiceResponse();
    try {
      // Throwing exception if the user is not having edit access on Branch Object
      if (!Schema.sObjectType.SCA_Review_History__c.Isupdateable()) {
        throw new InvalidOperationException(SCA_REVIEW_EDIT_ERROR);
      }
      // Querying branches which are pending for SCA review submission along
      // with their Attachment Id
      // clang-format off
        for (Flosum__Branch__c branchDetail : [
            SELECT Id,Name,
            (SELECT Id,Name
             FROM Attachments
             WHERE
              Name LIKE '____-__-__%'
             ORDER BY Name DESC LIMIT 1 ),
            (SELECT Id,Name,CreatedById,SCA_Integration_Status__c
             FROM SCA_Review_Histories__r
             WHERE
              SCA_Integration_Status__c =: REVIEW_STATUS_PENDING
             ORDER BY Name DESC LIMIT 1)
            FROM Flosum__Branch__c
            WHERE
             SCA_Integration_Status__c =:REVIEW_STATUS_PENDING
            WITH SECURITY_ENFORCED
        ]) {
        // clang-format on
        if (!branchDetail.SCA_Review_Histories__r.isempty()
            && !branchDetail.Attachments.isempty()) {
          branchDetailsList.add(branchDetail);
          SCA_Review_History__c scaReviewRecord = branchDetail.SCA_Review_Histories__r;
          scaReviewRecord.SCA_Integration_Status__c = REVIEW_STATUS_QUEUED;
          scaHistoryDetailList.add(scaReviewRecord);
          branchIdsSet.add(branchDetail.id);
        }
      }  // End for getBranchDetails
      if (!scaHistoryDetailList.isEmpty()) {
        update scaHistoryDetailList;
        if (!Test.isRunningTest()) {
          chatterPost();
        }  // End if Test.isRunningTest
      }
      // Setting response
      response.data.put('BranchDetails', branchDetailsList);
    } catch (Exception e) {
      response.success = false;
      response.messages.add(e.getMessage());
    }  // End catch
    return JSON.serialize(response);
  }  // End getBranchDetails method

  /**
   * @description: Chatter post to branches which are submitted for SCA Review
   **/
  public
  static void chatterPost() {
    List<ConnectApi.BatchInput> lstBatchInputs = new List<ConnectApi.BatchInput>();
    // clang-format off
    for (Flosum__Branch__c branch : [
         SELECT id,
          (SELECT Id, CreatedById
           FROM SCA_Review_Histories__r
           ORDER BY Name DESC LIMIT 1)
         FROM Flosum__Branch__c
         WHERE
          id IN:branchIdsSet
         WITH SECURITY_ENFORCED
    ]) {
      // clang-format on
      SCA_Review_History__c scaReviewHistoryVariable = new SCA_Review_History__c();
      scaReviewHistoryVariable = branch.SCA_Review_Histories__r;
      ConnectApi.FeedItemInput input =
          new FlosumChatterBuilder()
              .setSubjectId(branch.id)
              .addMention(scaReviewHistoryVariable.CreatedById)
              .setVisibility(ConnectApi.FeedItemVisibilityType.InternalUsers)
              .addText(' ' + BRANCH_SCA_ENQUED_MESSAGE)
              .getFeedItem();
      // Creating batch input instance using FeedItemInput and adding it to
      // lstBatchInputs
      ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(input);
      lstBatchInputs.add(batchInput);
      if (!Test.isRunningTest()) {
        ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), lstBatchInputs);
      }
    }
  }

  // Wrapper class to structure the response format with error handling and messages
  public
  class ServiceResponse {
    public
    List<String> messages;
    public
    Map<String, List<Flosum__Branch__c>> data;
    public
    Boolean success;

    // Constructor
    public
    ServiceResponse() {
      this.data = new Map<String, List<Flosum__Branch__c>>();
      this.success = true;
    }  // End constructor
  }    // End ServiceResponse Class
}