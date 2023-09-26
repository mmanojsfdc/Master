/**
 * @description  ITriggerHandler is a public interface to enforce consistent
 *               function names accross all trigger handlers. It also used in
 *               TriggerDispatcher to reduce duplicate flow control code in the
 *               Trigger definition.
 */
public
interface ITriggerHandler {
  void onBeforeInsert(List<sObject> newObjects,
      List<sObject> oldObjects,
      Map<ID, sObject> newMap,
      Map<ID, sObject> oldMap);

  void onAfterInsert(List<sObject> newObjects,
      List<sObject> oldObjects,
      Map<ID, sObject> newMap,
      Map<ID, sObject> oldMap);

  void onBeforeUpdate(List<sObject> newObjects,
      List<sObject> oldObjects,
      Map<ID, sObject> newMap,
      Map<ID, sObject> oldMap);

  void onAfterUpdate(List<sObject> newObjects,
      List<sObject> oldObjects,
      Map<ID, sObject> newMap,
      Map<ID, sObject> oldMap);

  void onBeforeDelete(List<sObject> newObjects,
      List<sObject> oldObjects,
      Map<ID, sObject> newMap,
      Map<ID, sObject> oldMap);

  void onAfterDelete(List<sObject> newObjects,
      List<sObject> oldObjects,
      Map<ID, sObject> newMap,
      Map<ID, sObject> oldMap);

  void onAfterUndelete(List<sObject> newObjects,
      List<sObject> oldObjects,
      Map<ID, sObject> newMap,
      Map<ID, sObject> oldMap);
}