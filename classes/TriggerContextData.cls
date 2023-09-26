/**
 * @description  TriggerContextData is a Parameter Object for Trigger Context
 *               Variables. It servces the purpose to hold the information from
 *               Trigger to TriggerDispatcher.
 */
public
class TriggerContextData {
  /*
   * The properties are defined with private modifier to prevent changes outside of Trigger
   * contexts. Unit tests contexts are allowd to modify the data to enable writing tests for
   * TriggerDispatcher. The design is to pass Trigger Context Variables to the TriggerDispatcher and
   * let the dispatcher handle the control flow. The only place a developer should touch
   * TriggerContextData is inside the Trigger definition using TriggerContextData constructor.
   */
  @TestVisible public boolean isExecuting {
    get;
    private
    set;
  }
  @TestVisible public boolean isInsert {
    get;
    private
    set;
  }
  @TestVisible public boolean isUpdate {
    get;
    private
    set;
  }
  @TestVisible public boolean isDelete {
    get;
    private
    set;
  }
  @TestVisible public boolean isUndelete {
    get;
    private
    set;
  }
  @TestVisible public boolean isBefore {
    get;
    private
    set;
  }
  @TestVisible public boolean isAfter {
    get;
    private
    set;
  }
  @TestVisible public List<sObject> newObjects {
    get;
    private
    set;
  }
  @TestVisible public List<sObject> oldObjects {
    get;
    private
    set;
  }
  @TestVisible public Map<ID, sObject> newMap {
    get;
    private
    set;
  }
  @TestVisible public Map<ID, sObject> oldMap {
    get;
    private
    set;
  }

  /**
   * Constructor of TriggerContextData. The consturctor assigns
   * all trigger context information in this data class.
   * All properties are private set and public get, so developer
   * cannot and should not modify values once the object is initialized.
   *
   * Due to Salesforce limitations, there is no compile time check
   * for the parameters passed into constructor.
   * Please make sure to pass all context variables in the right order!
   */
  public
  TriggerContextData(Boolean isExecuting,
      Boolean isInsert,
      Boolean isUpdate,
      Boolean isDelete,
      Boolean isUndelete,
      Boolean isBefore,
      Boolean isAfter,
      List<sObject> newObjects,
      List<sObject> oldObjects,
      Map<ID, sObject> newMap,
      Map<ID, sObject> oldMap) {
    this.isExecuting = isExecuting;
    this.isInsert = isInsert;
    this.isUpdate = isUpdate;
    this.isDelete = isDelete;
    this.isUndelete = isUndelete;
    this.isBefore = isBefore;
    this.isAfter = isAFter;
    this.newObjects = newObjects;
    this.oldObjects = oldObjects;
    this.newMap = newMap;
    this.oldMap = oldMap;
  }
}