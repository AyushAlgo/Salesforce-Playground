trigger ContactTrigger on Contact (before insert) {
    if(Trigger.isBefore && Trigger.isInsert) {
        checkDuplicateContact(Trigger.new, Trigger.oldMap);
    }

    public static void checkDuplicateContact(List<Contact> newList, Map<Id, Contact> oldMap) {
        Map<Id, Contact> alreadyPresentContacts = new Map<Id, Contact>([SELECT Id, FirstName, LastName, BirthDate, Phone FROM Contact]);
        
        // Data Already Present In Org
        Set<String> alreadyPresentFirstNames = new Set<String>();
        Set<String> alreadyPresentLastNames = new Set<String>();
        Set<Date> alreadyPresentBirthDates = new Set<Date>();
        Set<String> alreadyPresentPhones = new Set<String>();

        for(Id conId : alreadyPresentContacts.keySet()) {
            alreadyPresentFirstNames.add(alreadyPresentContacts.get(conId).FirstName);
            alreadyPresentLastNames.add(alreadyPresentContacts.get(conId).LastName);
            alreadyPresentBirthDates.add(alreadyPresentContacts.get(conId).Birthdate);
            alreadyPresentPhones.add(alreadyPresentContacts.get(conId).Phone);
        }

        for(Contact con : newList) {
            Boolean isFirstNameAlreadyPresent = alreadyPresentFirstNames.contains(con.FirstName);
            Boolean isLastNameAlreadyPresent = alreadyPresentLastNames.contains(con.LastName);
            Boolean isBirthDateAlreadyPresent = alreadyPresentBirthDates.contains(con.BirthDate);
            Boolean isPhoneAlreadyPresent = alreadyPresentPhones.contains(con.Phone);
            if(oldMap == null) {
                if(isFirstNameAlreadyPresent && isLastNameAlreadyPresent && isBirthDateAlreadyPresent && isPhoneAlreadyPresent) {
                    con.addError('**Duplicate Contact Found**');
                }
            } else if((con.FirstName != oldMap.get(con.id).FirstName)
                || (con.LastName != oldMap.get(con.id).LastName)
                || (con.Birthdate != oldMap.get(con.id).Birthdate)
                || (con.Phone != oldMap.get(con.id).Phone)) {
                // will run only for updates
                if(isFirstNameAlreadyPresent && isLastNameAlreadyPresent && isBirthDateAlreadyPresent && isPhoneAlreadyPresent) {
                    con.addError('**Duplicate Contact Found**');
                }
            }
        }
    }
}