@isTest(seeAllData = false)
public class BewerberMatcherControllerTest {

    static testMethod void getRelatedApplicantsWithoutDistance() {

		Id fluechtlingRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Flüchtling').getRecordTypeId();
        
        Account testAccount = new Account(Name = 'AccountName');
        insert testAccount;
        
        Job__c jobCustom = new Job__c(Name ='JobName1', Account_Name__c=testAccount.Id);
        insert jobCustom;

        Account testApplicant1 = new Account(FirstName = 'ApplicantName1First', LastName = 'ApplicantName1Last');
        testApplicant1.RecordTypeId = fluechtlingRecordTypeId;
        insert testApplicant1;

        Id ownerId1 = testApplicant1.OwnerId;
        
        Account testApplicant2 = new Account(FirstName = 'ApplicantName2First', LastName = 'ApplicantName2Last');
        testApplicant2.RecordTypeId = fluechtlingRecordTypeId;
        insert testApplicant2;
        
        String[] ownerList = new List<String>();
        ownerList.add(ownerId1);
        List<Account> relatedApplicants = BewerberMatcherController.getBewerber(jobCustom.Id, 0, ownerList);
        //All applicants are returned
        System.assertEquals(2, relatedApplicants.size());
	}
    
    static testMethod void getRelatedApplicantsWithDistanceNoMatch() {

		Id fluechtlingRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Flüchtling').getRecordTypeId();
        
        Account testAccount = new Account(Name = 'AccountName');
        insert testAccount;
        
        Job__c jobCustom = new Job__c(Name ='JobName', Account_Name__c=testAccount.Id);
        insert jobCustom;

        //Account testApplicant1 = new Account(Name = 'ApplicantName1', RecordTypeId = fluechtlingRecordTypeId);
        Account testApplicant1 = new Account(FirstName = 'ApplicantName1First', LastName = 'ApplicantName1Last', RecordTypeId = fluechtlingRecordTypeId);
        insert testApplicant1;
        Id ownerId1 = testApplicant1.OwnerId;

        Account testApplicant2 = new Account(FirstName = 'ApplicantName2First', LastName = 'ApplicantName2Last', RecordTypeId = fluechtlingRecordTypeId);
        insert testApplicant2;
        
        String[] ownerList = new List<String>();
        ownerList.add(ownerId1);
        List<Account> relatedApplicants = BewerberMatcherController.getBewerber(jobCustom.Id, 10, ownerList);
        //No jobs are returned
        System.assertEquals(2, relatedApplicants.size());
	}
    
    static testMethod void getRelatedApplicantsWithDistanceNoMatch2() {

		Id fluechtlingRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Flüchtling').getRecordTypeId();
        
        Account testAccountWithAddress = new Account(Name = 'AccountName', BillingStreet='Engasserbogen 24'
                                           , BillingCity='München', BillingPostalCode='80639', BillingCountry='Germany'
                                           , BillingLatitude=48.146372, BillingLongitude=11.511881);
        insert testAccountWithAddress;
        
        
        Job__c jobCustom = new Job__c(Name ='JobName', Account_Name__c=testAccountWithAddress.Id);
        insert jobCustom;

        Account testApplicant1 = new Account(FirstName = 'ApplicantName1First', LastName = 'ApplicantName1Last', BillingStreet='Alpenblickstraße 24'
                                           , BillingCity='Holzkirchen', BillingPostalCode='83607', BillingCountry='Germany'
                                           , BillingLatitude=47.884974018593450, BillingLongitude=11.701570050503868, RecordTypeId = fluechtlingRecordTypeId);
        insert testApplicant1;
        Id ownerId1 = testApplicant1.OwnerId;

        Account testApplicant2 = new Account(FirstName = 'ApplicantName2First', LastName = 'ApplicantName2Last');
        insert testApplicant2;
        
        String[] ownerList = new List<String>();
        ownerList.add(ownerId1);
        List<Account> relatedApplicants = BewerberMatcherController.getBewerber(jobCustom.Id, 10, ownerList);
        System.assertEquals(1, relatedApplicants.size());
	}
    
   static testMethod void getRelatedApplicantsWithDistanceTwoMatches() {

		Id fluechtlingRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Flüchtling').getRecordTypeId();
       
		Account testAccountWithAddress = new Account(Name = 'AccountName', BillingStreet='Engasserbogen 24'
                                           , BillingCity='München', BillingPostalCode='80639', BillingCountry='Germany'
                                           , BillingLatitude=48.146372, BillingLongitude=11.511881);
        insert testAccountWithAddress;
        
        Job__c jobCustom = new Job__c(Name ='JobName', Account_Name__c=testAccountWithAddress.Id);
        insert jobCustom;
              
        Account testApplicant1 = new Account(FirstName = 'Applicant1NameFirst', LastName = 'Applicant1NameLast', BillingStreet='Engasserbogen 32'
                                           , BillingCity='München', BillingPostalCode='80639', BillingCountry='Germany'
                                           , BillingLatitude=48.145733, BillingLongitude=11.511186, RecordTypeId = fluechtlingRecordTypeId);
        insert testApplicant1;
        Id ownerId1 = testApplicant1.OwnerId;

        Account testApplicant2 = new Account(FirstName = 'OtherNameFirst', LastName = 'OtherNameLast', BillingStreet='Engasserbogen 24'
                                           , BillingCity='München', BillingPostalCode='80639', BillingCountry='Germany'
                                           , BillingLatitude=48.146372, BillingLongitude=11.511881, RecordTypeId = fluechtlingRecordTypeId);                            
        insert testApplicant2;

		Account testApplicant3 = new Account(FirstName = 'Applicant3NameFirst', LastName = 'Applicant3NameLast', BillingStreet='Kornmarkt 1'
                                           , BillingCity='Nürnberg', BillingPostalCode='90402', BillingCountry='Germany'
                                           , BillingLatitude=49.448236, BillingLongitude=11.075542, RecordTypeId = fluechtlingRecordTypeId);
        insert testApplicant3;
       
        String[] ownerList = new List<String>();
        ownerList.add('');
        List<Account> relatedApplicants = BewerberMatcherController.getBewerber(jobCustom.Id, 10, ownerList);
        System.assertEquals(3, relatedApplicants.size());
	}

   static testMethod void getActiveUsers() {       
        List<User> activeUser = BewerberMatcherController.getActiveUsers(true);
		List<User> inActiveUser = BewerberMatcherController.getActiveUsers(false);
	}    

   static testMethod void getGoogleMapsURL() {       
       Id fluechtlingRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Flüchtling').getRecordTypeId();
       Account testAccount = new Account(Name = 'AccountName');
       insert testAccount;
       
       Job__c jobCustom = new Job__c(Name ='JobName1', Account_Name__c=testAccount.Id);
       insert jobCustom;
       
       Account testApplicant1 = new Account(FirstName = 'ApplicantName1First', LastName = 'ApplicantName1Last');
       testApplicant1.RecordTypeId = fluechtlingRecordTypeId;
       insert testApplicant1;

       String url = BewerberMatcherController.getGoogleMapsURL(jobCustom.Id, testApplicant1.Id);
	}    
}