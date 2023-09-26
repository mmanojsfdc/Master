/**
 * @group: SCA Review
 * @description: Webservice class to insert the SCA Result and SCA Violation Records
 * @testclass: SCAScanResultsTest
 */
@RestResource(urlMapping = '/SCAScanResults/*') global with sharing class SCAScanResults {
  private
  static final string SCA_REVIEW_HISTORY_STATUS_SUCCESS = 'Successful';
  private
  static final string SCA_REVIEW_HISTORY_STATUS_FAILURE = 'Failure';
  private
  static final string SCA_REVIEW_HISTORY_SUCCESS_MESSAGE = LABEL.SCA_REVIEW_HISTORY_SUCCESS;

  /**
   * @description: Creates the SCA result and SCA Violation records
   **/
  @HttpPost global static void recordCreation(String scaReviewHistory, String contents) {
    // List to store the Violation Records
    List<SCA_Violations__c> scaViolationRecordsList = new List<SCA_Violations__c>();
    // sObject Variable to update a SCA Review History
    SCA_Review_History__c scaReviewHistoryRecord = new SCA_Review_History__c();
    try {
      // Update the id and SCA integration status for SCA Review History record
      scaReviewHistoryRecord.id = scaReviewHistory;
      scaReviewHistoryRecord.SCA_Integration_Status__c = SCA_REVIEW_HISTORY_STATUS_SUCCESS;
      String[] csvFileLines;
      // Create the SCA Result Record
      SCA_Result__c scaResultRecord = new SCA_Result__c();
      scaResultRecord.SCA_Review_History__c = scaReviewHistory;
      // Check if its SCA_Result__c isCreateable
      if (Schema.sObjectType.SCA_Result__c.isCreateable()) {
        insert scaResultRecord;
      }
      // split the contents based on the unique identifier
      if (contents != null && !string.isEmpty(contents)) {
        csvFileLines = contents.split('!%!');
      }
      // check the size and create the SCA Violations records accordingly.
      if (csvFileLines != null && csvFileLines.size() > 0) {
        for (Integer i = 0; i < csvFileLines.size(); i++) {
          String[] csvRecordData = csvFileLines[i].split(',');
          if (csvRecordData.size() > 0) {
            SCA_Violations__c violationRecord = new SCA_Violations__c();
            violationRecord.File_Name__c = csvRecordData[0].trim();
            violationRecord.Priority__c = Integer.valueOf(csvRecordData[1].trim());
            violationRecord.Line_Number__c = Integer.valueOf(csvRecordData[2].trim());
            violationRecord.Error_Description__c = csvRecordData[3].trim();
            violationRecord.Rule_Set__c = csvRecordData[4].trim();
            violationRecord.Rule__c = csvRecordData[5].trim();
            violationRecord.SCA_Result__c = scaResultRecord.id;
            scaViolationRecordsList.add(violationRecord);
          }
        }
      }
      if (Schema.sObjectType.SCA_Violations__c.isCreateable()
          && Schema.sObjectType.SCA_Review_History__c.Isupdateable()) {
        if (scaViolationRecordsList.size() > 0) {
          insert scaViolationRecordsList;
        }
        update scaReviewHistoryRecord;
        chatterPost(scaReviewHistory, SCA_REVIEW_HISTORY_SUCCESS_MESSAGE);
      }
    } catch (Exception e) {
      scaReviewHistoryRecord.SCA_Integration_Status__c = SCA_REVIEW_HISTORY_STATUS_FAILURE;
      update scaReviewHistoryRecord;
      chatterPost(scaReviewHistory, string.ValueOf(e));
    }
  }

  /**
   * @description: Chatter post to branches which are submitted for SCA Review
   **/
  public
  static void chatterPost(id scaReviewHistoryId, String message) {
    List<ConnectApi.BatchInput> lstBatchInputs = new List<ConnectApi.BatchInput>();
    // clang-format off
    for (SCA_Review_History__c scaReviewHistoryRecord : [
         SELECT id,CreatedById, Branch__c
         FROM SCA_Review_History__c
         WHERE
          id =:scaReviewHistoryId
         WITH SECURITY_ENFORCED
    ]) {
      // clang-format on
      ConnectApi.FeedItemInput input =
          new FlosumChatterBuilder()
              .setSubjectId(scaReviewHistoryRecord.Branch__c)
              .addMention(scaReviewHistoryRecord.CreatedById)
              .setVisibility(ConnectApi.FeedItemVisibilityType.InternalUsers)
              .addText(' ' + message)
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
}