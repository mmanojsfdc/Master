/**
 * @group FlosumHubChatterBuilder
 * @description A  Chatter builder that improves
 * readability and reduces setup logic
 *
 * @usage
 * Example 1
 * Task t = new Task(Subject = 'test chatter');
 * insert t;
 *
 * new CopadoHubChatterBuilder()
 *  .addText('test chatter post')
 *  .setSubjectId(t.Id)
 *  .postChatter();
 *
 * Example 2
 * Task t = new Task(Subject = 'test chatter and mention');
 * insert t;
 *
 * new CopadoHubChatterBuilder()
 *  .addText('test chatter post with mention')
 *  .addMention(UserInfo.getUserId())
 *  .setSubjectId(t.Id)
 *  .setVisibility(ConnectApi.FeedItemVisibilityType.InternalUsers)
 *  .postChatter();
 */
public
class FlosumChatterBuilder {
  public
  static final String ERROR_BLANK_USER_ID = 'userId cannot be blank';
  public
  static final String ERROR_BLANK_RECORD_ID = 'recordId cannot be blank';
  @TestVisible private static Integer timesPostChatterCalled = 0;
  private
  ConnectApi.FeedItemInput feed;
  private
  ConnectApi.MentionSegmentInput mentionSegment;
  private
  ConnectApi.MessageBodyInput messageInput;
  private
  ConnectApi.TextSegmentInput textInput;

  /**
   * @description Constructor
   */
  public
  FlosumChatterBuilder() {
    feed = new ConnectApi.FeedItemInput();
    messageInput = new ConnectApi.MessageBodyInput();
    messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
  }

  /**
   * @description Add mention by user id
   * @param userId
   * @return FlosumChatterBuilder
   */
  public
  FlosumChatterBuilder addMention(Id userId) {
    if (String.isBlank(userId)) {
      throw new IllegalArgumentException(ERROR_BLANK_USER_ID);
    }
    ConnectApi.MentionSegmentInput mention = new ConnectApi.MentionSegmentInput();
    mention.Id = userId;
    messageInput.messageSegments.add(mention);
    return this;
  }

  /**
   * @description Add input text
   * @param text
   * @return FlosumChatterBuilder
   */
  public
  FlosumChatterBuilder addText(String text) {
    if (String.isEmpty(text)) {
      // no need to add empty string
      return this;
    }
    ConnectApi.TextSegmentInput textInput = new ConnectApi.TextSegmentInput();
    textInput.text = text;
    messageInput.messageSegments.add(textInput);
    return this;
  }

  /**
   * @description Set chatter subject by id
   * @param setSubjectId
   * @return FlosumChatterBuilder
   */
  public
  FlosumChatterBuilder setSubjectId(Id recordId) {
    if (String.isBlank(recordId)) {
      throw new IllegalArgumentException(ERROR_BLANK_RECORD_ID);
    }
    feed.subjectId = recordId;
    return this;
  }

  /**
   * @description Set visibility for chatter post
   * @param setSubjectId
   * @return FlosumHubChatterBuilder
   */
  public
  FlosumChatterBuilder setVisibility(ConnectApi.FeedItemVisibilityType visibility) {
    feed.visibility = visibility;
    return this;
  }

  /**
   * @description Post to chatter
   * @return ConnectApi.FeedElement
   */
  public
  ConnectApi.FeedElement postChatter() {
    feed.body = messageInput;
    feed.feedElementType = ConnectApi.FeedElementType.FeedItem;
    if (Test.isRunningTest()) {
      timesPostChatterCalled++;
      return null;
    }
    return ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feed);
  }

  /**
   * @description Set body and feedElementType for chatter post
   * @return ConnectApi.FeedItemInput
   */
  public
  ConnectApi.FeedItemInput getFeedItem() {
    feed.body = messageInput;
    feed.feedElementType = ConnectApi.FeedElementType.FeedItem;
    return feed;
  }
}