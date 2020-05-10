@isTest
private class subscriptionTest {
    // The following test methods provide adequate code coverage 
    // for the subscription email class.
    static testMethod void testSubscriptionLead() {
    
       // Create a new email and envelope object.
       Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
    
       // Create a new test lead and insert it in the test method.
       Lead l = new lead(firstName='John', 
                lastName='Lead',
                Company='Salesforce', 
                Email='lead@acme.com');
       insert l;
            
       // Test with the subject that matches the unsubscribe statement.
       email.subject = 'test Unsubscribe SMS';
       env.fromAddress = 'lead@acme.com';
       
       // Call the class and test it with the data in the testMethod.
       subscription subscriptionObj = new subscription();
       subscriptionObj.handleInboundEmail(email, env );                            
    }

    static testMethod void testSubscriptionPersonAccount() {
    
       // Create a new email and envelope object.
       Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
       // Create a new test personaccount and insert it in the test method.
	   RecordType personAccountRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Flüchtling' and SObjectType = 'Account'];
       Account a = new Account(firstName='John', 
                    lastName='Personaccount',
                    RecordType = personAccountRecordType,
                    PersonEmail='personaccount@acme.com');
       insert a;
        
       // Test with the subject that matches the unsubscribe statement.
       email.subject = 'test Unsubscribe SMS';
       env.fromAddress = 'personaccount@acme.com';
       
       // Call the class and test it with the data in the testMethod.
       subscription subscriptionObj = new subscription();
       subscriptionObj.handleInboundEmail(email, env );
                            
    }

    static testMethod void testSubscriptionContact() {
    
       // Create a new email and envelope object.
       Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
       // Create a new test contact and insert it in the test method.
       Contact c = new Contact(firstName='John', 
                    lastName='Contact', 
                    Email='contact@acme.com');
       insert c;
        
       // Test with the subject that matches the unsubscribe statement.
       email.subject = 'test Unsubscribe SMS';
       env.fromAddress = 'contact@acme.com';
       
       // Call the class and test it with the data in the testMethod.
       subscription subscriptionObj = new subscription();
       subscriptionObj.handleInboundEmail(email, env );
                            
    }

    static testMethod void testSubscriptionInvalid() {
    
       // Create a new email and envelope object.
       Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
                
       // Test with the subject that matches the unsubscribe statement.
       email.subject = 'test Unsubscribe SMS';
       env.fromAddress = 'invalid@acme.com';
       
       // Call the class and test it with the data in the testMethod.
       subscription subscriptionObj = new subscription();
       subscriptionObj.handleInboundEmail(email, env );                            
    }
    
}