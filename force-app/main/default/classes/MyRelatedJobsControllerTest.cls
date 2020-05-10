@isTest(seeAllData = false)
public class MyRelatedJobsControllerTest {

    static testMethod void getRelatedJobsWithoutDistance() {
        
        Account testAccount = new Account(Name = 'AccountName');
        insert testAccount;
        
        Job__c jobCustom1 = new Job__c(Name ='JobName1', Account_Name__c=testAccount.Id);
        Job__c jobCustom2 = new Job__c(Name ='JobName2', Account_Name__c=testAccount.Id);
        insert jobCustom1;
        insert jobCustom2;
        
        List<Job__c> relatedJobs = MyRelatedJobsController.getRelatedJobs(testAccount.Id, 0);
        //All jobs are returned
        System.assertEquals(2, relatedJobs.size());
	}
    
    static testMethod void getRelatedJobsWithDistance() {
        
        Account testAccount = new Account(Name = 'AccountName');
        insert testAccount;
        
        Job__c jobCustom1 = new Job__c(Name ='JobName1', Account_Name__c=testAccount.Id);
        Job__c jobCustom2 = new Job__c(Name ='JobName2', Account_Name__c=testAccount.Id);
        insert jobCustom1;
        insert jobCustom2;
        
        List<Job__c> relatedJobs = MyRelatedJobsController.getRelatedJobs(testAccount.Id, 10);
        //All jobs are returned
        System.assertEquals(2, relatedJobs.size());
	}
    
    static testMethod void getRelatedJobsWithDistanceAndNoMatch() {
        Account testAccountWithAddress = new Account(Name = 'AccountName', BillingStreet='Engasserbogen 24'
                                           , BillingCity='München', BillingPostalCode='80639', BillingCountry='Germany'
                                           , BillingLatitude=48.146372, BillingLongitude=11.511881
                                           , BillingGeocodeAccuracy='Block');
        insert testAccountWithAddress;
        
        Account testAccountWithoutAddress = new Account(Name = 'AccountNameWithoutAddress');
		insert testAccountWithoutAddress;
        
        Job__c jobCustom1 = new Job__c(Name ='JobName1', Account_Name__c=testAccountWithoutAddress.Id);
        Job__c jobCustom2 = new Job__c(Name ='JobName2', Account_Name__c=testAccountWithoutAddress.Id);
        insert jobCustom1;
        insert jobCustom2;
        
        List<Job__c> relatedJobs = MyRelatedJobsController.getRelatedJobs(testAccountWithAddress.Id, 10);
        System.assertEquals(0, relatedJobs.size());
	}
    
   static testMethod void getRelatedJobsWithDistanceAndOneMatch() {
        Account testAccountWithAddress = new Account(Name = 'AccountName', BillingStreet='Engasserbogen 24'
                                           , BillingCity='München', BillingPostalCode='80639', BillingCountry='Germany'
                                           , BillingLatitude=48.146372, BillingLongitude=11.511881
                                           , BillingGeocodeAccuracy='Block');
        insert testAccountWithAddress;
        
       
        Account testAccountWithoutAddress = new Account(Name = 'AccountNameWithoutAddress');
		insert testAccountWithoutAddress;
        Job__c jobCustomTestAccountWithoutAddress = new Job__c(Name ='JobNameTestAccountWithoutAddress', Account_Name__c=testAccountWithoutAddress.Id);
        insert jobCustomTestAccountWithoutAddress;
       
        Account testAccountWithIncompleteAddress = new Account(Name = 'AccountNameWithIncompleteAddress', BillingCity='München', BillingPostalCode='80639');
		insert testAccountWithIncompleteAddress;
        Job__c jobCustomTestAccountWithIncompleteAddress = new Job__c(Name ='JobNameTestAccountWithIncompleteAddress', Account_Name__c=testAccountWithIncompleteAddress.Id);
        insert jobCustomTestAccountWithIncompleteAddress;

       
       
        Account testAccountWithAddress2 = new Account(Name = 'AccountName2', BillingStreet='Engasserbogen 32'
                                           , BillingCity='München', BillingPostalCode='80639', BillingCountry='Germany'
                                           , BillingLatitude=48.145733, BillingLongitude=11.511186
                                           , BillingGeocodeAccuracy='Block');
        insert testAccountWithAddress2;
        Job__c jobCustomTestAccountWithAddress2 = new Job__c(Name ='JobNameTestAccountWithAddress2', Account_Name__c=testAccountWithAddress2.Id);
        insert jobCustomTestAccountWithAddress2;
       
       
       
        Account testAccountWithAddress3 = new Account(Name = 'AccountName3', BillingStreet='Kornmarkt 1'
                                           , BillingCity='Nürnberg', BillingPostalCode='90402', BillingCountry='Germany'
                                           , BillingLatitude=49.448236, BillingLongitude=11.075542
                                           , BillingGeocodeAccuracy='Block');
        insert testAccountWithAddress3;
        Job__c jobCustomTestAccountWithAddress3 = new Job__c(Name ='JobNameTestAccountWithAddress2', Account_Name__c=testAccountWithAddress3.Id);
        insert jobCustomTestAccountWithAddress3;
       
       
       
        List<Job__c> relatedJobs = MyRelatedJobsController.getRelatedJobs(testAccountWithAddress.Id, 10);
        // Only jobCustomTestAccountWithAddress2 should be returned since it is the only one where the parent account
        // has a address set wich is inside of 10 km of the address of testAccountWithAddress
        System.assertEquals(1, relatedJobs.size());
       	System.assertEquals('JobNameTestAccountWithAddress2', relatedJobs[0].Name);
	}
}