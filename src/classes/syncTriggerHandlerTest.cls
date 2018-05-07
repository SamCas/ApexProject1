/**
 * Created by Samuel on 5/4/18.
 */

@IsTest
private class syncTriggerHandlerTest {
    @IsTest
    static void it_should_insert_account_inSyncBilling_and_inSyncShipping()
    {
        List<Account> newAccounts = UtilClass.accountGenerator(15, true);
        List<In_Sync_Shipping__c> querryInSyncShipping = [SELECT Shipping_Street__c,Shipping_Country__c, Shipping_State__c, Shipping_Postal_Code__c, Shipping_City__c, Account__c FROM In_Sync_Shipping__c];
        List<In_Sync_Billing__c> querryInSyncBilling = [SELECT Billing_Street__c,  Billing_Country__c, Billing_State__c, Billing_Postal_Code__c, Billing_City__c,Account__c FROM In_Sync_Billing__c];
        Map<Id, In_Sync_Shipping__c> newShippingMap = RecordFillerClass.makeCustomMapShipping(querryInSyncShipping);
        Map<Id, In_Sync_Billing__c> newBillingMap = RecordFillerClass.makeCustomMapBilling(querryInSyncBilling);
        for (Integer i = 0; i < newAccounts.size(); i++)
        {
            System.assertEquals(true, newShippingMap.containsKey(newAccounts[i].Id));
            System.assertEquals(true, newBillingMap.containsKey(newAccounts[i].Id));
        }
    }
    @IsTest
    static void it_should_update_inSyncBilling_and_inSyncShipping_from_Account_Update()
    {
        List<Account> newAccounts = UtilClass.accountGenerator(2, true);
        List<In_Sync_Shipping__c> querryInSyncShipping = [SELECT Shipping_Street__c,Shipping_Country__c, Shipping_State__c, Shipping_Postal_Code__c, Shipping_City__c, Account__c FROM In_Sync_Shipping__c];
        List<In_Sync_Billing__c> querryInSyncBilling = [SELECT Billing_Street__c,  Billing_Country__c, Billing_State__c, Billing_Postal_Code__c, Billing_City__c,Account__c FROM In_Sync_Billing__c];
        Map<Id, In_Sync_Shipping__c> newShippingMap = RecordFillerClass.makeCustomMapShipping(querryInSyncShipping);
        Map<Id, In_Sync_Billing__c> newBillingMap = RecordFillerClass.makeCustomMapBilling(querryInSyncBilling);
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
        for (Account acc : newAccounts)
        {
            Integer i = 0;
            System.debug('@@-------Account Start No. ' + i + '-------@@');
            for (String str : fieldsToCheckForUpdateOnBilling.keySet())
            {
                acc.BillingPostalCode = '6477' + i;
                acc.BillingCountry = 'USA';
                acc.BillingStreet = 'San Marcos';
                acc.BillingState = 'Texas';
                acc.BillingCity = 'San Antonio';
                System.debug('@@Test Class Billing: ' + acc.get(str));
            }
            for (String str : fieldsToCheckForUpdateOnShipping.keySet())
            {
                acc.ShippingPostalCode = '6532' + i;
                acc.ShippingCountry = 'MEX';
                acc.ShippingStreet = 'Jose Lopez';
                acc.ShippingState = 'Nuevo Leon';
                acc.ShippingCity = 'Monterrey';
                System.debug('@@Test Class Shipping: ' + acc.get(str));
            }
            i ++;
        }
        update newAccounts;
        List<In_Sync_Shipping__c> newQuerryInSyncShipping = [SELECT Shipping_Street__c,Shipping_Country__c, Shipping_State__c, Shipping_Postal_Code__c, Shipping_City__c, Account__c FROM In_Sync_Shipping__c];
        List<In_Sync_Billing__c> newQuerryInSyncBilling = [SELECT Billing_Street__c,  Billing_Country__c, Billing_State__c, Billing_Postal_Code__c, Billing_City__c,Account__c FROM In_Sync_Billing__c];
        Map<Id, In_Sync_Shipping__c> shippingMap = RecordFillerClass.makeCustomMapShipping(newQuerryInSyncShipping);
        Map<Id, In_Sync_Billing__c> billingMap = RecordFillerClass.makeCustomMapBilling(newQuerryInSyncBilling);
        for (Account acc : newAccounts)
        {
            In_Sync_Shipping__c newShippingObj = shippingMap.get(acc.Id);
            In_Sync_Billing__c newBillingObj = billingMap.get(acc.Id);
            System.debug('@@-------Account Start-------@@');
            for (String str : fieldsToCheckForUpdateOnShipping.keySet())
            {
                String field = fieldsToCheckForUpdateOnShipping.get(str);
                System.debug('Account: ' + acc.get(str) + ' ' + 'ShippingObj: ' + newShippingObj.get(field));
                System.equals(acc.get(str), newShippingObj.get(field));
            }
            for (String str : fieldsToCheckForUpdateOnBilling.keySet())
            {
                String field = fieldsToCheckForUpdateOnBilling.get(str);
                System.debug('Account: ' + acc.get(str) + ' ' + 'ShippingObj: ' + newBillingObj.get(field));
                System.equals(acc.get(str), newBillingObj.get(field));
            }
        }
    }
    @IsTest
    static void it_should_delete_Account_along_with_inSyncShipping_and_inSyncBilling()
    {
        List<Account> newAccounts = UtilClass.accountGenerator(2, true);
        List<In_Sync_Shipping__c> querryInSyncShipping = [SELECT Shipping_Street__c,Shipping_Country__c, Shipping_State__c, Shipping_Postal_Code__c, Shipping_City__c, Account__c FROM In_Sync_Shipping__c];
        List<In_Sync_Billing__c> querryInSyncBilling = [SELECT Billing_Street__c,  Billing_Country__c, Billing_State__c, Billing_Postal_Code__c, Billing_City__c,Account__c FROM In_Sync_Billing__c];
        delete newAccounts;
        List<In_Sync_Shipping__c> newQuerryInSyncShipping = [SELECT Shipping_Street__c,Shipping_Country__c, Shipping_State__c, Shipping_Postal_Code__c, Shipping_City__c, Account__c FROM In_Sync_Shipping__c];
        List<In_Sync_Billing__c> newQuerryInSyncBilling = [SELECT Billing_Street__c,  Billing_Country__c, Billing_State__c, Billing_Postal_Code__c, Billing_City__c,Account__c FROM In_Sync_Billing__c];
        System.assertEquals(true, newQuerryInSyncBilling.isEmpty());
        System.assertEquals(true, newQuerryInSyncShipping.isEmpty());
    }
}