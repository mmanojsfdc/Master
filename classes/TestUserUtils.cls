/**
 * @description: Generic class intended for test user setup
 */
@isTest public with sharing class TestUserUtils {
  /**
   * @description: Create test user based on the profileName, roleName
   * @param profileName : Name of the profile
   * @param roleName : Name of the userrole
   * @return: User of the specified profile, role
   **/
  public
  static User createTestUser(String profileName, String roleName) {
    // Null check for profilename
    if (String.isBlank(profileName)) {
      return null;
    }
    // Creating unique Username
    String orgId = UserInfo.getOrganizationId();
    String dateString =
        String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
    Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
    String orgName = UserInfo.getOrganizationName().deleteWhitespace();
    String uniqueUserName = orgId + dateString + randomInt + '@' + orgName + '.com';
    // Querying the specified profile
    // clang-format off
    Profile specifiedProfile = [
      SELECT Id
      FROM Profile
      WHERE
       Name =:profileName
      ];
    // clang-format on
    // Creates the System.runas user
    User testUser = new User(Alias = 'standt',
        Email = UserInfo.getUserEmail(),
        EmailEncodingKey = 'UTF-8',
        LastName = UserInfo.getLastName(),
        LanguageLocaleKey = UserInfo.getLocale(),
        LocaleSidKey = UserInfo.getLocale(),
        ProfileId = specifiedProfile.Id,
        IsActive = true,
        TimeZoneSidKey = UserInfo.getTimeZone().getID(),
        UserName = uniqueUserName);
    // Query and assign the specified role
    if (!String.isBlank(roleName)) {
      // clang-format off
      UserRole specifiedRole = [
          SELECT Id
          FROM UserRole
          WHERE
           Name =:roleName
      ];
      // clang-format on
      testUser.UserRoleId = specifiedRole.Id;
    }
    // Insert the test user
    insert testUser;
    return testUser;
  }  // End createTestUser method
}