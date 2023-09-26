/**
 * @description Trigger which defines the Events and passes to
 * ComponentTriggerHandler().
 */
trigger ComponentTrigger on Flosum__Component__c(before insert,
    before update,
    before delete,
    after update,
    after insert,
    after delete,
    after undelete) {
  TriggerContextData contextData = new TriggerContextData(Trigger.isExecuting,
      Trigger.isInsert,
      Trigger.isUpdate,
      Trigger.isDelete,
      Trigger.isUndelete,
      Trigger.isBefore,
      Trigger.isAfter,
      Trigger.new,
      Trigger.old,
      Trigger.newMap,
      Trigger.oldMap);
  ITriggerHandler handler = ComponentTriggerHandler.getInstance();
  TriggerDispatcher dispatcher = new TriggerDispatcher(handler, contextData);
  dispatcher.dispatch();
}