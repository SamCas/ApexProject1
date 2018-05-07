/**
 * Created by Samuel on 4/25/18.
 */

trigger syncTriggerHandler on Account (after insert, after update, before delete) {
    if (Trigger.isAfter && Trigger.isInsert) {
        List<In_Sync_Billing__c> newRecordListBilling = new List<In_Sync_Billing__c>();
        List<In_Sync_Shipping__c> newRecordListShipping = new List<In_Sync_Shipping__c>();
        for (Account accountFieldFill : Trigger.new) {
           In_Sync_Billing__c add_InSyncBilling = RecordFillerClass.onAccountInsertionAddBilling(accountFieldFill.BillingStreet,accountFieldFill.BillingCity, accountFieldFill.BillingState, accountFieldFill.BillingCountry, accountFieldFill.BillingPostalCode, accountFieldFill.Id, accountFieldFill.Name);
            In_Sync_Shipping__c add_InSyncShipping = RecordFillerClass.onAccountInsertionAddShipping(accountFieldFill.ShippingStreet,accountFieldFill.ShippingCity, accountFieldFill.ShippingState, accountFieldFill.ShippingCountry, accountFieldFill.ShippingPostalCode, accountFieldFill.Id, accountFieldFill.Name);
            newRecordListBilling.add(add_InSyncBilling);
            newRecordListShipping.add(add_InSyncShipping);
        }insert newRecordListBilling;
        insert newRecordListShipping;
    }
    if (Trigger.isAfter && Trigger.isUpdate) {
        List<In_Sync_Billing__c> inSyncBillingRecords = [SELECT Billing_Country__c, Billing_State__c, Billing_City__c, Billing_Postal_Code__c,Billing_Street__c, Account__c FROM  In_Sync_Billing__c WHERE Account__c IN : Trigger.newMap.keySet()];
        List<In_Sync_Shipping__c> inSyncShippingRecords = [SELECT Shipping_Country__c, Shipping_State__c, Shipping_City__c, Shipping_Postal_Code__c,Shipping_Street__c, Account__c FROM  In_Sync_Shipping__c WHERE Account__c IN : Trigger.newMap.keySet()];
        Map<String, String> fieldsToCheckForUpdateOnBilling = new Map<String, String> {
                'BillingStreet' => 'Billing_Street__c',
                'BillingCountry' => 'Billing_Country__c',
                'BillingState' => 'Billing_State__c',
                'BillingPostalCode' => 'Billing_Postal_Code__c',
                'BillingCity' => 'Billing_City__c'
        };
        Map<String, String> fieldsToCheckForUpdateOnShipping = new Map<String, String> {
                'ShippingStreet' => 'Shipping_Street__c',
                'ShippingCountry' => 'Shipping_Country__c',
                'ShippingState' => 'Shipping_State__c',
                'ShippingPostalCode' => 'Shipping_Postal_Code__c',
                'ShippingCity' => 'Shipping_City__c'
        };
        List<In_Sync_Billing__c> billingListToUpdate = new List<In_Sync_Billing__c>();
        List<In_Sync_Shipping__c> shippingListToUpdate = new List<In_Sync_Shipping__c>();
        for (Account newAccount : Trigger.new) {
            Account oldAccount = Trigger.oldMap.get(newAccount.Id);
            Map<Id, In_Sync_Shipping__c> newShippingMap = RecordFillerClass.makeCustomMapShipping(inSyncShippingRecords);
            Map<Id, In_Sync_Billing__c> newBillingMap = RecordFillerClass.makeCustomMapBilling(inSyncBillingRecords);
            In_Sync_Billing__c billingNewObj = RecordFillerClass.compareAccountsBilling(oldAccount, newAccount, fieldsToCheckForUpdateOnBilling, newBillingMap);
            In_Sync_Shipping__c shippingNewObj = RecordFillerClass.compareAccountsShipping(oldAccount, newAccount, fieldsToCheckForUpdateOnShipping, newShippingMap);
            billingListToUpdate.add(billingNewObj);
            shippingListToUpdate.add(shippingNewObj);
        } update billingListToUpdate;
        update shippingListToUpdate;
    }
    if (Trigger.isBefore && Trigger.isDelete) {
        List<In_Sync_Billing__c> inSyncBillingRecords = [SELECT Billing_Country__c, Billing_State__c, Billing_City__c, Billing_Postal_Code__c,Billing_Street__c, Account__c FROM  In_Sync_Billing__c WHERE Account__c IN : Trigger.oldMap.keySet()];
        List<In_Sync_Shipping__c> inSyncShippingRecords = [SELECT Shipping_Country__c, Shipping_State__c, Shipping_City__c, Shipping_Postal_Code__c,Shipping_Street__c, Account__c FROM  In_Sync_Shipping__c WHERE Account__c IN : Trigger.oldMap.keySet()];
        System.debug('@@Shipping Records: ' + inSyncShippingRecords);
        System.debug('@@Billing Records: ' + inSyncBillingRecords);
        /*List<In_Sync_Shipping__c> shippingListToDelete = new List<In_Sync_Shipping__c>();
        List<In_Sync_Billing__c> billingListToDelete = new List<In_Sync_Billing__c>();
        Map<Id, In_Sync_Shipping__c> newShippingMap = RecordFillerClass.makeCustomMapShipping(inSyncShippingRecords);
        Map<Id, In_Sync_Billing__c> newBillingMap = RecordFillerClass.makeCustomMapBilling(inSyncBillingRecords);
        for (Account accountFieldFill : Trigger.old) {
            In_Sync_Shipping__c shippingObjToDelete = newShippingMap.get(accountFieldFill.Id);
            In_Sync_Billing__c billingObjToDelete = newBillingMap.get(accountFieldFill.Id);
            shippingListToDelete.add(shippingObjToDelete);
            billingListToDelete.add(billingObjToDelete);
            System.debug('@@Shipping Object to delete: ' +  shippingObjToDelete);
            System.debug('@@Billing Object to delete: ' + billingObjToDelete);
        } */
        delete inSyncBillingRecords;
        delete inSyncShippingRecords;
    }
}