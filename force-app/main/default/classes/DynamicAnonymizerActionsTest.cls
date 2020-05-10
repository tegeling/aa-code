@isTest(SeeAllData = false)
public class DynamicAnonymizerActionsTest {
    @isTest static void testAnonymizeFields() {

        // Get Record Type Ids
        Id klientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Fluchtling').getRecordTypeId();
        // create test records
        Date birthdate = Date.today() - 1;
        Account klient = new Account(Salutation = 'Herr', FirstName = 'Vorname', LastName = 'Nachname', RecordTypeId = klientRecordTypeId, PersonBirthdate = birthdate);
        insert klient;

        List<DynamicAnonymizerActions.anonymizeRequests> requests = new List<DynamicAnonymizerActions.anonymizeRequests>();
        DynamicAnonymizerActions.anonymizeRequests request = new DynamicAnonymizerActions.anonymizeRequests();
        request.record = klient.Id;
        request.complianceGroupDelete = 'DELETE';
        request.complianceGroupAnonymize = 'ANONYMIZE';
        requests.add(request);

        // run test
        Test.startTest();
        DynamicAnonymizerActions.anonymizeFields(requests);
        Test.stopTest();

    }
}