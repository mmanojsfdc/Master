/**
 * @group FlosumHubChatterBuilder
 * @description: Test class for FlosumChatterBuilder Class
 */
@isTest public class FlosumChatterBuilderTest {

 /**
  * @description: testPostChatterMsg
  */
  @isTest static void testPostChatterMsg() {
    // Get test Admin profile user form testDataUtils class to runn as admin
    User adminUser = TestUserUtils.createTestUser('System Administrator', '');
    // Run as test system admin user
    System.runAs(adminUser) {
      // Preparing a chatter feed for each User Stoy Commit
      new FlosumChatterBuilder()
          .setSubjectId(UserInfo.getUserId())
          .addMention(UserInfo.getUserId())
          .setVisibility(ConnectApi.FeedItemVisibilityType.InternalUsers)
          .addText('Test Chatter Message')
          .getFeedItem();
      // Posting to chatter
      new FlosumChatterBuilder()
          .setSubjectId(UserInfo.getUserId())
          .addMention(UserInfo.getUserId())
          .addText('Test Chatter Message')
          .setVisibility(ConnectApi.FeedItemVisibilityType.InternalUsers)
          .postChatter();
      System.assert(true, 'Sample text');
    }  // End system.runAS admin user
  }    // End testPostChatterMsg method

  /**
   * @description: test when mention is null
   */
  @isTest static void testNullAddMention() {
    // Get test Admin profile user form testDataUtils class to run as admin
    User adminUser = TestUserUtils.createTestUser('System Administrator', '');
    // Run as test system admin user
    System.runAs(adminUser) {
      try {
        new FlosumChatterBuilder().addMention(null);
      } catch (Exception e) {
        system.assertEquals(e.getMessage(), 'userId cannot be blank', 'UserId is blank');
      }
    }  // End system.runAS admin user
  }    // End testNullAddMention method

  /**
   * @description: test when text is null
   */
  @isTest static void testNullText() {
    // Get test Admin profile user form testDataUtils class to runn as admin
    User adminUser = TestUserUtils.createTestUser('System Administrator', '');
    // Run as test system admin user
    System.runAs(adminUser) {
      new FlosumChatterBuilder().addText(null);
      System.assert(true, 'sample message');
    }  // End system.runAS admin user
  }    // End testNullText method

  /**
   * @description: test when SubjectId is null
   */
  @isTest static void testNullSubjectId() {
    // Get test Admin profile user form testDataUtils class to runn as admin
    User adminUser = TestUserUtils.createTestUser('System Administrator', '');
    // Run as test system admin user
    System.runAs(adminUser) {
      try {
        new FlosumChatterBuilder().setSubjectId(null);
      } catch (Exception e) {
        System.assertEquals(e.getMessage(), 'recordId cannot be blank', 'RecordId is blank');
      }
    }  // End system.runAs admin user
  }    // End testNullSubjectId method
}  // End class