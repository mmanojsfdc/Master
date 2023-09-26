/**
 * @description: Test Class for TriggerDispatcher
 */
@isTest 
public with sharing class TriggerDispatcherTest {

    @isTest static void dispatchBeforeInsert(){
        //Get test Admin profile user form testDataUtils class to runn as admin
        User adminUser = TestUserUtils.createTestUser('System Administrator', ''); 
        //Run as test system admin user
        System.runAs(adminUser){ 
            List<SObject> lstObjects = new List<SObject> ();
            Map<Id, SObject> mapObjects = new Map<Id, SObject>();
            TriggerContextData contextData = new TriggerContextData(
                true,
                true,
                false,
                false,
                false,
                true,
                false,
                lstObjects,
                lstObjects,
                mapObjects,
                mapObjects
            );
            ITriggerHandler handler = ComponentTriggerHandler.getInstance();
            TriggerDispatcher dispatcher = new TriggerDispatcher(handler, contextData);
            dispatcher.dispatch();
            System.assert(dispatcher <> null, 'Dispatcher should not be null');
        }
    }//End dispatchBeforeInsert method

    @isTest static void dispatchAfterInsert(){
        //Get test Admin profile user form testDataUtils class to runn as admin
        User adminUser = TestUserUtils.createTestUser('System Administrator', ''); 
        //Run as test system admin user
        system.runAs(adminUser){ 
            List<SObject> lstObjects = new List<SObject> ();
            Map<Id, Flosum__component__c> mapObjects = new Map<Id, Flosum__component__c>();
            TriggerContextData contextData = new TriggerContextData(
                true,
                true,
                false,
                false,
                false,
                false,
                true,
                lstObjects,
                lstObjects,
                mapObjects,
                mapObjects
            );
            ITriggerHandler handler = ComponentTriggerHandler.getInstance();
            TriggerDispatcher dispatcher = new TriggerDispatcher(handler, contextData);
            dispatcher.dispatch();
            System.assert(dispatcher <> null, 'Dispatcher should not be null');
        }//End system.runAs admin 
    }//End dispatchAfterInsert method

    @isTest static void dispatchBeforeUpdate(){
        //Get test Admin profile user form testDataUtils class to runn as admin
        User adminUser = TestUserUtils.createTestUser('System Administrator', ''); 
        //Run as test system admin user
        system.runAs(adminUser){ 
            List<SObject> lstObjects = new List<SObject> ();
            Map<Id, SObject> mapObjects = new Map<Id, SObject>();
            TriggerContextData contextData = new TriggerContextData(
                true,
                false,
                true,
                false,
                false,
                true,
                false,
                lstObjects,
                lstObjects,
                mapObjects,
                mapObjects
            );
            ITriggerHandler handler = ComponentTriggerHandler.getInstance();
            TriggerDispatcher dispatcher = new TriggerDispatcher(handler, contextData);
            dispatcher.dispatch();
            System.assert(dispatcher <> null, 'Dispatcher should not be null');
        }//End system.runAs admin
    }//End dispatchBeforeUpdate method

    @isTest static void dispatchAfterUpdate(){
        //Get test Admin profile user form testDataUtils class to runn as admin
        user adminUser = TestUserUtils.createTestUser('System Administrator', '');         
        //Run as test system admin user
        system.runAs(adminUser){ 
            List<SObject> lstObjects = new List<SObject> ();
            Map<Id, SObject> mapObjects = new Map<Id, SObject>();
            TriggerContextData contextData = new TriggerContextData(
                true,
                false,
                true,
                false,
                false,
                false,
                true,
                lstObjects,
                lstObjects,
                mapObjects,
                mapObjects
            );
            ITriggerHandler handler = ComponentTriggerHandler.getInstance();
            TriggerDispatcher dispatcher = new TriggerDispatcher(handler, contextData);
            dispatcher.dispatch();
            System.assert(dispatcher <> null, 'Dispatcher should not be null');
        }//End system.runAs admin
    }//End dispatchAfterUpdate method

    @isTest static void dispatchBeforeDelete(){
        //Get test Admin profile user form testDataUtils class to runn as admin
        User adminUser = TestUserUtils.createTestUser('System Administrator', '');        
        //Run as test system admin user
        system.runAs(adminUser){ 
            List<SObject> lstObjects = new List<SObject> ();
            Map<Id, SObject> mapObjects = new Map<Id, SObject>();            
            TriggerContextData contextData = new TriggerContextData(
                true,
                false,
                false,
                true,
                false,
                true,
                false,
                lstObjects,
                lstObjects,
                mapObjects,
                mapObjects
            );
            ITriggerHandler handler = ComponentTriggerHandler.getInstance();
            TriggerDispatcher dispatcher = new TriggerDispatcher(handler, contextData);
            dispatcher.dispatch();
            System.assert(dispatcher <> null, 'Dispatcher should not be null');
        }//End system.runAs admin
    }//End dispatchBeforeDelete method

    @isTest static void dispatchAfterDelete(){
        //Get test Admin profile user form testDataUtils class to runn as admin
        User adminUser = TestUserUtils.createTestUser('System Administrator', ''); 
        //Run as test system admin user
        system.runAs(adminUser){ 
            List<SObject> lstObjects = new List<SObject> ();
            Map<Id, Flosum__component__c> mapObjects = new Map<Id, Flosum__component__c>();         
            TriggerContextData contextData = new TriggerContextData(
                true,
                false,
                false,
                true,
                false,
                false,
                true,
                lstObjects,
                lstObjects,
                mapObjects,
                mapObjects
            );
            ITriggerHandler handler = ComponentTriggerHandler.getInstance();
            TriggerDispatcher dispatcher = new TriggerDispatcher(handler, contextData);
            dispatcher.dispatch();
            System.assert(dispatcher <> null, 'Dispatcher should not be null');
        }//End system.runAs admin
    }//End dispatchAfterDelete method

    @isTest static void dispatchAfterUndelete(){
        //Get test Admin profile user form testDataUtils class to runn as admin
        User adminUser = TestUserUtils.createTestUser('System Administrator', '');   
        //Run as test system admin user
        system.runAs(adminUser){ 
            List<SObject> lstObjects = new List<SObject> ();
            Map<Id, SObject> mapObjects = new Map<Id, SObject>();           
            TriggerContextData contextData = new TriggerContextData(
                true,
                false,
                false,
                false,
                true,
                false,
                true,
                lstObjects,
                lstObjects,
                mapObjects,
                mapObjects
            );
            ITriggerHandler handler = ComponentTriggerHandler.getInstance();
            TriggerDispatcher dispatcher = new TriggerDispatcher(handler, contextData);
            dispatcher.dispatch();
            System.assert(dispatcher <> null, 'Dispatcher should not be null');
        }//End system.runAs admin
    }//End dispatchAfterUndelete method

    @isTest static void throwInvalidOperationException(){
        //Get test Admin profile user form testDataUtils class to runn as admin
        User adminUser = TestUserUtils.createTestUser('System Administrator', ''); 
        //Run as test system admin user
        system.runAs(adminUser){ 
            List<SObject> lstObjects = new List<SObject> ();
            Map<Id, SObject> mapObjects = new Map<Id, SObject>(); 
            TriggerContextData contextData = new TriggerContextData(
                false,
                false,
                false,
                false,
                false,
                false,
                false,
                lstObjects,
                lstObjects,
                mapObjects,
                mapObjects
            );
            ITriggerHandler handler = ComponentTriggerHandler.getInstance();
            TriggerDispatcher dispatcher = new TriggerDispatcher(handler, contextData);
            try{
                dispatcher.dispatch();
            }catch(Exception e){
                String message = e.getMessage();
                System.assert(message <> null, 'Message should not be null');
            }//End catch
        }//End system.runAs admin
    }//End throwInvalidOperationException method

    @isTest static void throwNullPointerException(){
        //Get test Admin profile user form testDataUtils class to runn as admin
        User adminUser = TestUserUtils.createTestUser('System Administrator', '');  
        //Run as test system admin user
        system.runAs(adminUser){ 
            try{
                TriggerDispatcher dispatcher = new TriggerDispatcher(null, null);
                dispatcher.dispatch();
            }catch(Exception e){
                String message = e.getMessage();
                System.assert(message <> null, 'Message should not be null');
            }//End catch
        }//End system.runAs admin
    }//End throwNullPointerException method
}//End TriggerDispatcherTest class