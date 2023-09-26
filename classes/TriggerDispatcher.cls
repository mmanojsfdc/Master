/**
 * @param triggerHandler is used for event handling
 * @param TriggerContextData is used for flow control
 * @description  TriggerDispatcher is designed to extract trigger flow control
 *               logic to a single class.
 */
public
class TriggerDispatcher {
  private
  final ITriggerHandler triggerHandler;
  private
  final TriggerContextData triggerContext;
  private
  static final String className = TriggerDispatcher.class.getName();

  public
  TriggerDispatcher(ITriggerHandler triggerHandler, TriggerContextData triggerContext) {
    if (triggerHandler == null) {
      logAndThrowNullException();
    }
    if (triggerContext == null) {
      logAndThrowNullException();
    }
    this.triggerHandler = triggerHandler;
    this.triggerContext = triggerContext;
  }

  private
  static void logAndThrowNullException() {
    Exception e = new NullPointerException();
    // ErrorLogger.logError(className, 'constructor()', e);
    throw e;
  }
  // clang-format off
  @SuppressWarnings('PMD.EmptyStatementBlock')
  public void dispatch() {
    if (!triggerContext.isExecuting) {
      // dispatch() is not in the context of Trigger. Will not fire trigger
      // Exception e = new InvalidOperationException();
      // ErrorLogger.logError(className, 'dispatch()', e);
      // throw e;
    }
    // clang-format on

    if (triggerContext.isBefore) {
      if (triggerContext.isInsert) {
        beforeInsert();
      } else if (triggerContext.isUpdate) {
        beforeUpdate();
      } else if (triggerContext.isDelete) {
        beforeDelete();
      }
    } else if (triggerContext.isAfter) {
      if (triggerContext.isInsert) {
        afterInsert();
      } else if (triggerContext.isUpdate) {
        afterUpdate();
      } else if (triggerContext.isDelete) {
        afterDelete();
      } else if (triggerContext.isUndelete) {
        afterUndelete();
      }
    }
  }

  private
  void beforeInsert() {
    triggerHandler.onBeforeInsert(triggerContext.newObjects,
        triggerContext.oldObjects,
        triggerContext.newMap,
        triggerContext.oldMap);
  }

  private
  void afterInsert() {
    triggerHandler.onAfterInsert(triggerContext.newObjects,
        triggerContext.oldObjects,
        triggerContext.newMap,
        triggerContext.oldMap);
  }

  private
  void beforeUpdate() {
    triggerHandler.onBeforeUpdate(triggerContext.newObjects,
        triggerContext.oldObjects,
        triggerContext.newMap,
        triggerContext.oldMap);
  }

  private
  void afterUpdate() {
    triggerHandler.onAfterUpdate(triggerContext.newObjects,
        triggerContext.oldObjects,
        triggerContext.newMap,
        triggerContext.oldMap);
  }

  private
  void beforeDelete() {
    triggerHandler.onBeforeDelete(triggerContext.newObjects,
        triggerContext.oldObjects,
        triggerContext.newMap,
        triggerContext.oldMap);
  }

  private
  void afterDelete() {
    triggerHandler.onAfterDelete(triggerContext.newObjects,
        triggerContext.oldObjects,
        triggerContext.newMap,
        triggerContext.oldMap);
  }

  private
  void afterUndelete() {
    triggerHandler.onAfterUndelete(triggerContext.newObjects,
        triggerContext.oldObjects,
        triggerContext.newMap,
        triggerContext.oldMap);
  }
}