public with sharing class TableHandler {
    @AuraEnabled
    public static List<Contact> getContacts(){
        try {
            List<Contact> contacts = [SELECT Id, FirstName, LastName, BirthDate, Account.Name FROM Contact LIMIT 30];
            return contacts;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}