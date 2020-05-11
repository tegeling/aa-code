public class BewerberMatcherController {
  @AuraEnabled
  public static List<Account> getBewerber(
    Id recordId,
    Integer maxDistance,
    String[] ownerIds
  ) {
    Id klientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Fluchtling')
      .getRecordTypeId();

    // If maxDistance was set then return only the Applicants (PersonAccounts) within the range
    // The workaround Integer.valueOf(mayDisance) is needed because
    // this is not working: "if (maxDistance > 0 ){" -> Leads to Iternal Salesforce.com Error
    if (Integer.valueOf(maxDistance) > 0) {
      Job__c[] jobs = [
        SELECT
          Billing_City__c,
          Job_Location__c,
          Billing_Latitude__c,
          Billing_Longitude__c,
          Billing_Street__c,
          Billing_Zip_Postal_Code__c,
          Id
        FROM Job__c
        WHERE Id = :recordId
        LIMIT 1
      ];

      if (jobs.size() > 0 && jobs[0].Job_Location__c != null) {
        //address cutomerAddress = account[0].BillingAddress;
        Double myLat = jobs[0].Billing_Latitude__c;
        Double myLong = jobs[0].Billing_Longitude__c;
        List<Account> queryApplicants;
        if ((ownerIds.size() > 0) && (ownerIds[0] != '')) {
          queryApplicants = new List<Account>(
            [
              SELECT
                FirstName,
                LastName,
                BillingCity,
                BillingLatitude,
                BillingLongitude,
                Berufswunsch__c,
                Deutschkenntnisse__c
              // Would be great if this DISTANCE (in SELECT) worked (such that the actual distance can be displayed)
              // but this does not work for now:
              //", DISTANCE( Account_Name__r.BillingAddress, :cutomerAddress, 'mi') dist"
              FROM Account
              WHERE
                RecordTypeId = :klientRecordTypeId
                AND OwnerId IN :ownerIds
                AND DISTANCE(
                  BillingAddress,
                  GEOLOCATION(:myLat, :myLong),
                  'km'
                ) < :maxDistance
              ORDER BY
                DISTANCE(BillingAddress, GEOLOCATION(:myLat, :myLong), 'km') ASC
            ]
          );
        } else {
          queryApplicants = new List<Account>(
            [
              SELECT
                FirstName,
                LastName,
                BillingCity,
                BillingLatitude,
                BillingLongitude,
                Berufswunsch__c,
                Deutschkenntnisse__c
              // Would be great if this DISTANCE (in SELECT) worked (such that the actual distance can be displayed)
              // but this does not work for now:
              //", DISTANCE( Account_Name__r.BillingAddress, :cutomerAddress, 'mi') dist"
              FROM Account
              WHERE
                RecordTypeId = :klientRecordTypeId
                AND DISTANCE(
                  BillingAddress,
                  GEOLOCATION(:myLat, :myLong),
                  'km'
                ) < :maxDistance
              ORDER BY
                DISTANCE(BillingAddress, GEOLOCATION(:myLat, :myLong), 'km') ASC
            ]
          );
        }

        // Create new list of SObjects Account to calculate distance and set as custom field
        //
        List<Account> resultApplicants = new List<Account>();
        for (Account a : queryApplicants) {
          Account newAccount = new Account();
          newAccount.Record_Id__c = a.Id;
          newAccount.FirstName = a.FirstName;
          newAccount.LastName = a.LastName;
          newAccount.BillingCity = a.BillingCity;
          newAccount.Berufswunsch__c = a.Berufswunsch__c;
          newAccount.Deutschkenntnisse__c = a.Deutschkenntnisse__c;
          //newAccount.Distance_Job__c = a.expr0;

          Location locJob = Location.newInstance(myLat, myLong);
          Location locApplicant = Location.newInstance(
            a.BillingLatitude,
            a.BillingLongitude
          );
          Double dist = Location.getDistance(locJob, locApplicant, 'km');
          Decimal distDecimal = Decimal.valueOf(dist).setScale(2);
          newAccount.Distance_Job__c = String.valueOf(distDecimal);
          resultApplicants.add(newAccount);
        }
        return resultApplicants;
      }
    }

    // If no maxDistance was set, then return all Applicants
    return [
      SELECT
        FirstName,
        LastName,
        BillingCity,
        Berufswunsch__c,
        Deutschkenntnisse__c
      FROM Account
      WHERE RecordTypeId = :klientRecordTypeId
    ];
  }

  @AuraEnabled
  public static List<User> getActiveUsers(Boolean activeUsers) {
    if (activeUsers) {
      return [
        SELECT Alias, FirstName, LastName
        FROM User
        WHERE
          IsActive = true
          AND (Profile.Name = 'System Administrator'
          OR Profile.Name = 'StayWelcome Profile')
        ORDER BY Alias
      ];
    } else {
      return [
        SELECT Alias, FirstName, LastName
        FROM User
        WHERE
          Profile.Name = 'System Administrator'
          OR Profile.Name = 'StayWelcome Profile'
        ORDER BY Alias
      ];
    }
  }

  @AuraEnabled
  public static String getGoogleMapsURL(Id jobId, Id applicantId) {
    Job__c[] jobs = [
      SELECT Billing_City__c, Billing_Street__c, Billing_Zip_Postal_Code__c
      FROM Job__c
      WHERE Id = :jobId
      LIMIT 1
    ];
    Account[] applicant = [
      SELECT BillingCity, BillingStreet, BillingPostalCode
      FROM Account
      WHERE Id = :applicantId
      LIMIT 1
    ];
    String origin =
      applicant[0].BillingStreet +
      '+' +
      applicant[0].BillingPostalCode +
      '+' +
      applicant[0].BillingCity;
    String destination =
      jobs[0].Billing_Street__c +
      '+' +
      jobs[0].Billing_Zip_Postal_Code__c +
      '+' +
      jobs[0].Billing_City__c;
    String googleMapURL =
      'https://www.google.com/maps/dir/?api=1&origin=' +
      origin +
      '&destination=' +
      destination +
      '&travelmode=transit';
    System.debug('*** ' + origin + ' - ' + destination + ' - ' + googleMapURL);
    return googleMapURL;
  }
}