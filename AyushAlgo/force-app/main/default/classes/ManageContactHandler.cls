public without sharing class ManageContactHandler {
    @AuraEnabled
    public static List<Contact> getContact(String conId){
        try {
            List<Contact> conList = [SELECT Id, FirstName, LastName, Birthdate, Invited__c, 
                                        HasOptedOutOfFax, Number_Of_Units__c, Currencies__c, Type__c 
                                        FROM Contact WHERE Id =: conId];
            return conList;
            //return UserInfo.getProfileId();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void upsertContact(String conDetails){
        try {
            String objType='Contact';
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType leadSchema = schemaMap.get(objType);
            Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
            Map<String, String> apiToDataType = new Map<String, String>();
            for (String fieldName: fieldMap.keySet()) {
                String fieldApiName = fieldMap.get(fieldName).getDescribe().getName();
                Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
                apiToDataType.put(fieldApiName, String.valueOf(fielddataType));
            }

            for(String api : apiToDataType.keySet()){
                System.debug('>> ' + api + ' = ' + apiToDataType.get(api));
            }
            
            Map<String, Object> detailsMap = (Map<String, Object>)JSON.deserializeUntyped(conDetails);
            Contact con = new Contact();
            for(String field : detailsMap.keySet()) {
                if(apiToDataType.containsKey(field)) {
                    String dataType = apiToDataType.get(field);
                    if(dataType == 'INTEGER') {
                        con.put(field, Integer.valueOf(detailsMap.get(field)));
                    } else if(dataType == 'BOOLEAN') {
                        con.put(field, Boolean.valueOf(detailsMap.get(field)));
                    } else if(dataType == 'CURRENCY') {
                        con.put(field, ((Decimal)detailsMap.get(field)));
                    } else if(dataType == 'DATE') {
                        String datevalue = String.valueOf(detailsMap.get(field));
                        String yyyy = datevalue.split('-')[0];
                        String mm = datevalue.split('-')[1];
                        String dd = datevalue.split('-')[2];
                        Date dt = Date.parse(mm+'/'+dd+'/'+yyyy);
                        //Date dt = (Date)JSON.deserialize(String.valueOf(detailsMap.get(field)), Date.class);
                        con.put(field, dt);
                    } else if(dataType == 'DATETIME') {
                        Datetime dt = (DateTime)JSON.deserialize(String.valueOf(detailsMap.get(field)), DateTime.class);
                        con.put(field, dt);
                    } else if(dataType == 'DOUBLE') {
                        con.put(field, Double.valueOf(detailsMap.get(field)));
                    } else if(dataType == 'LONG') {
                        con.put(field, ((Decimal)detailsMap.get(field)));
                    } else {
                        con.put(field, String.valueOf(detailsMap.get(field)));
                    }
                }
                upsert con;
                System.debug(field + '===>' + detailsMap.get(field));
            }            
            System.debug('final ###> ' + con);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}