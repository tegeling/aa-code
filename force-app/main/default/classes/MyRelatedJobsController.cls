public class MyRelatedJobsController {
    
    @AuraEnabled
    public static List<Job__c> getRelatedJobs (Id recordId, Integer maxDistance) {
        
        // If maxDistance was set then return only the Jobs within the range
        // The workaround Integer.valueOf(mayDisance) is needed because
        // this is not working: "if (maxDistance > 0 ){" -> Leads to Iternal Salesforce.com Error
        if (Integer.valueOf(maxDistance) > 0 ){ 
            
            Account[] account = [SELECT Name, BillingAddress, BillingLatitude, BillingLongitude FROM Account
                                 WHERE Id=:recordId LIMIT 1];
            
            if (account.size() > 0 && account[0].BillingLatitude != null && account[0].BillingLongitude != null) {

                address cutomerAddress = account[0].BillingAddress;
                List<Job__c> resultJobs = new List<Job__c>(                
                    [SELECT Job__c.Name, Description__c, Anzahl_Bewerber__c, Account_Name__r.Name, Account_Name__r.BillingAddress,
                     Account_Name__r.BillingLatitude, Account_Name__r.BillingCity
                     // Would be great if this DISTANCE (in SELECT) worked (such that the actual distance can be displayed) 
                     // but this does not work for now:
                     //", DISTANCE( Account_Name__r.BillingAddress, :cutomerAddress, 'mi') dist"
                     FROM Job__c
                     WHERE DISTANCE(Account_Name__r.BillingAddress, :cutomerAddress, 'km') < :maxDistance
                     ORDER BY DISTANCE(Account_Name__r.BillingAddress, :cutomerAddress, 'km') ASC
                    ]
                );
                
                return resultJobs;
            }
        }
        
        // If no maxDistance was set, or the Klient has no Address set, then return all jobs
        return [SELECT Job__c.Name, Description__c, Anzahl_Bewerber__c, Account_Name__r.Name, 
                Account_Name__r.BillingCity 
                FROM Job__c
               ]; 
    }
    
}