/**
 * Created by Samuel on 4/26/18.
 */
//TODO: Maybe make another class to make isChanged() method UtilClass.
public with sharing class RecordFillerClass {
    public static In_Sync_Billing__c onAccountInsertionAddBilling(String street, String city, String state, String country, String postalCode, String accId, String accName) {
        In_Sync_Billing__c new_InSyncBilling_Object = new In_Sync_Billing__c(
                Name = accName,
                Billing_Street__c = street,
                Billing_City__c = city,
                Billing_State__c = state,
                Billing_Country__c = country,
                Billing_Postal_Code__c = postalCode,
                Account__c = accId
        );
        return new_InSyncBilling_Object;
    }
    public static In_Sync_Shipping__c onAccountInsertionAddShipping(String street, String city, String state, String country, String postalCode, String accId, String accName){
        In_Sync_Shipping__c new_InSyncShipping_Object = new In_Sync_Shipping__c(
                Name = accName,
                Shipping_Street__c = street,
                Shipping_City__c = city,
                Shipping_State__c = state,
                Shipping_Country__c = country,
                Shipping_Postal_Code__c = postalCode,
                Account__c = accId
        );
        return new_InSyncShipping_Object;
    }
    public static In_Sync_Billing__c compareAccountsBilling(Account oldAcc, Account newAcc, Map<String, String> fieldsToCheckBilling, Map<Id, In_Sync_Billing__c> billingMap) {
        In_Sync_Billing__c newBillingObj = billingMap.get(oldAcc.Id);
        System.debug('@@StartingBillingObj: ' + newBillingObj);
        for (String str : fieldsToCheckBilling.keySet()) {
            if (oldAcc.get(str) != newAcc.get(str)) {
                String field = fieldsToCheckBilling.get(str);
                newBillingObj.put(field, newAcc.get(str));
            }
        } System.debug('@@UpdatedObj: ' + newBillingObj);
        return newBillingObj;
    }
    public static In_Sync_Shipping__c compareAccountsShipping(Account oldAcc, Account newAcc, Map<String, String> fieldsToCheckBilling, Map<Id, In_Sync_Shipping__c> shippingMap) {
        In_Sync_Shipping__c newBillingObj = shippingMap.get(oldAcc.Id);
        System.debug('@@StartingBillingObj: ' + newBillingObj);
        for (String str : fieldsToCheckBilling.keySet()) {
            if (oldAcc.get(str) != newAcc.get(str)) {
                String field = fieldsToCheckBilling.get(str);
                newBillingObj.put(field, newAcc.get(str));
            }
        } System.debug('@@UpdatedObj: ' + newBillingObj);
        return newBillingObj;
    }
    public static Map<Id, In_Sync_Shipping__c> makeCustomMapShipping (List<In_Sync_Shipping__c> objList) {
        Map<Id, In_Sync_Shipping__c> newCustomMap = new Map<Id, In_Sync_Shipping__c>();
        for (In_Sync_Shipping__c syncObj : objList) {
            newCustomMap.put(syncObj.Account__c, syncObj);
        }
        return newCustomMap;
    }
    public static Map<Id, In_Sync_Billing__c> makeCustomMapBilling (List<In_Sync_Billing__c> objList) {
        Map<Id, In_Sync_Billing__c> newCustomMap = new Map<Id, In_Sync_Billing__c>();
        for (In_Sync_Billing__c syncObj : objList) {
            newCustomMap.put(syncObj.Account__c, syncObj);
        }
        return newCustomMap;
    }
}