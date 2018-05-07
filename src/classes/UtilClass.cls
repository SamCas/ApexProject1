/**
 * Created by Samuel on 5/4/18.
 */

public with sharing class UtilClass {
    public static List<Account> accountGenerator(Integer numberOfAccounts, Boolean shouldInsert){
        List<Account> newAccounts = new List<Account>();
        for (Integer i = 0; i < numberOfAccounts; i++) {
                Account testAccount = new Account(
                        Name = 'TestAcc' + i,
                        BillingStreet = 'Jose Valentin',
                        BillingState = 'California',
                        BillingPostalCode = '25262',
                        BillingCity = 'Santa Rosa',
                        BillingCountry = 'USA',
                        ShippingStreet = 'Manuel Velorio',
                        ShippingState = 'Nuevo Leon',
                        ShippingPostalCode = '64770',
                        ShippingCity = 'Monterrey',
                        ShippingCountry = 'MEX'
                );
                newAccounts.add(testAccount);
        } if(shouldInsert == true) insert newAccounts;
        return newAccounts;
    }
}