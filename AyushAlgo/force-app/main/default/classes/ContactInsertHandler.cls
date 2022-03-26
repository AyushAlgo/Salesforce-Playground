public with sharing class ContactInsertHandler {
    @AuraEnabled
    public static string insertContact(String lastName, String firstName, String phone, Date birthdate){
        try {
            Contact con = new Contact(LastName=lastName, FirstName=firstName, Phone=phone, Birthdate=birthdate);
            insert con;
            return String.valueOf(con.Id);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}