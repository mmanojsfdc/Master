/**
 * @group CaseTriggerHandler
 * @description An implementation of TriggerHandler that handles all trigger
 * events for the Component object. Please use getInstance() to get
 * a singleton instance instead of using constructor() which will
 * fail during compile time.
 */

public
with sharing class ComponentTriggerHandler implements ITriggerHandler {
  private
  static ITriggerHandler instance;

  /**
   * @description Method checks for existing instance of handler and if not present
   * then creates one.
   * @return ITriggerHandler type of object.
   */
  public
  static ITriggerHandler getInstance() {
    if (instance == null) {
      instance = new ComponentTriggerHandler();
    }
    return instance;
  }
  // clang-format off
  @SuppressWarnings('PMD.EmptyStatementBlock')
  public
  void onBeforeInsert(List<sObject> newObjects,
      List<sObject> oldObjects,
      Map<ID, sObject> newMap,
      Map<ID, sObject> oldMap) {
  }

  @SuppressWarnings('PMD.EmptyStatementBlock')
  public
  void onBeforeUpdate(List<sObject> newObjects,
      List<sObject> oldObjects,
      Map<ID, sObject> newMap,
      Map<ID, sObject> oldMap) {
  }

  public
  void onAfterInsert(List<sObject> newObjects,
      List<sObject> oldObjects,
      Map<ID, sObject> newMap,
      Map<ID, sObject> oldMap) {
    ComponentTriggerService componentTriggerServiceInstance = ComponentTriggerService.getInstance();
    componentTriggerServiceInstance.checkHasApexCodeBasedOnComponentType(newMap);
  }  // End onAfterInsert method

  @SuppressWarnings('PMD.EmptyStatementBlock')
  public
  void onAfterUpdate(List<sObject> newObjects,
      List<sObject> oldObjects,
      Map<ID, sObject> newMap,
      Map<ID, sObject> oldMap) {
  }  // End onAfterUpdate method

  @SuppressWarnings('PMD.EmptyStatementBlock')
  public
  void onBeforeDelete(List<sObject> newObjects,
      List<sObject> oldObjects,
      Map<ID, sObject> newMap,
      Map<ID, sObject> oldMap) {
  }  // End onBeforeDelete method

  public
  void onAfterDelete(List<sObject> newObjects,
      List<sObject> oldObjects,
      Map<ID, sObject> newMap,
      Map<ID, sObject> oldMap) {
    ComponentTriggerService componentTriggerServiceInstance = ComponentTriggerService.getInstance();
    componentTriggerServiceInstance.uncheckHasApexCodeBasedOnComponentType(oldMap);
    componentTriggerServiceInstance.uncheckIsSCAPassedAndCodeCoverageMet(oldMap);          
  }  // End onAfterDelete method

  @SuppressWarnings('PMD.EmptyStatementBlock')
  public
  void onAfterUndelete(List<sObject> newObjects,
      List<sObject> oldObjects,
      Map<ID, sObject> newMap,
      Map<ID, sObject> oldMap) {
  }  // End onAfterUndelete method
}