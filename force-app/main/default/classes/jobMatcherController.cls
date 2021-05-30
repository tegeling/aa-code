// Used
public with sharing class jobMatcherController {
  public class Filters {
    public String recordId { get; set; }
    public String searchKey { get; set; }
    public String createdDate { get; set; }
    public Decimal maxDistance { get; set; }
    public String[] categories { get; set; }
    public String[] owners { get; set; }
  }

  @AuraEnabled(Cacheable=true)
  public static User[] getAllAccountOwners() {
    Set<User> setOwners = new Set<User>(
      [
        SELECT Id, Name
        FROM User
        WHERE Id IN (SELECT OwnerId FROM Account)
        ORDER BY Name
      ]
    );
    List<User> allOwners = new List<User>(setOwners);
    return allOwners;
  }

  @AuraEnabled(Cacheable=true)
  public static User[] getActiveAccountOwners() {
    Id applicantRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Fluchtling')
      .getRecordTypeId();
    Set<User> setOwners = new Set<User>(
      [
        SELECT Id, Name
        FROM User
        WHERE
          Id IN (
            SELECT OwnerId
            FROM Account
            WHERE RecordTypeId = :applicantRecordTypeId
          )
          AND IsActive = TRUE
        ORDER BY Name
      ]
    );
    List<User> activeOwners = new List<User>(setOwners);
    return activeOwners;
  }

  @AuraEnabled(Cacheable=true)
  public static List<Job__c> getJobs(String filters) {
    String recordId, key, whereClause = '';
    String orderByClause = ' ORDER BY Name';
    Decimal maxDistance;
    String[] categories, owners = new List<String>{};
    String[] criteria = new List<String>{};
    Account[] account;
    List<Job__c> queryJobs = new List<Job__c>();
    List<Job__c> resultJobs = new List<Job__c>();
    List<Id> jobIdsWithMatch = new List<Id>();
    if (!String.isEmpty(filters)) {
      Filters jobFilters = (Filters) JSON.deserializeStrict(
        filters,
        jobMatcherController.Filters.class
      );
      recordId = jobFilters.recordId;
      account = [
        SELECT Name, BillingAddress, BillingLatitude, BillingLongitude
        FROM Account
        WHERE Id = :recordId
        LIMIT 1
      ];
      if (account.size() > 0) {
        address accountAddress = account[0].BillingAddress;
      }
      if (!String.isEmpty(jobFilters.searchKey)) {
        key = '\'' + jobFilters.searchKey + '\'';
        String searchquery =
          'FIND ' +
          key +
          ' IN ALL FIELDS RETURNING Job__c(Id)';
        List<List<sObject>> searchList = search.query(searchquery);
        Job__c[] jobsWithMatch = (Job__c[]) searchList[0];
        for (Job__c j : jobsWithMatch) {
          jobIdsWithMatch.add(j.Id);
        }
        if (jobIdsWithMatch.size() > 0) {
          criteria.add('Id IN :jobIdsWithMatch');
        }
      }
      if (!String.isEmpty(jobFilters.createdDate)) {
        Datetime jobCreatedDate = Datetime.valueOf(
          jobFilters.createdDate.replace('T', ' ')
        );
        //Datetime jobCreatedDate = Datetime.parse(jobFilters.createdDate);
        criteria.add('CreatedDate >= :jobCreatedDate');
      }
      if (jobFilters.maxDistance > 0) {
        maxDistance = jobFilters.maxDistance;
        criteria.add(
          'DISTANCE(Job_Location__c, GEOLOCATION(' +
          account[0].BillingLatitude +
          ',' +
          account[0].BillingLongitude +
          '), \'km\') < ' +
          maxDistance
        );
        orderByClause =
          ' ORDER BY DISTANCE(Job_Location__c, GEOLOCATION(' +
          account[0].BillingLatitude +
          ',' +
          account[0].BillingLongitude +
          '), \'km\') ASC';
      }

      if (jobFilters.categories != null) {
        categories = jobFilters.categories;
        criteria.add('Type__c IN :categories');
      }

      if (criteria.size() > 0) {
        whereClause = 'WHERE ' + String.join(criteria, ' AND ');
      }
    }
    String query =
      'SELECT Job__c.Name, Type__c, Active__c, Standort__c, Description__c, Anzahl_Bewerber__c, Account_Name__r.Name, Billing_City__c, Billing_Street__c, Billing_Zip_Postal_Code__c, Billing_Latitude__c, Billing_Longitude__c, CreatedDate' +
      ' FROM Job__c ' +
      whereClause +
      orderByClause;
    queryJobs = Database.query(query);
    if (account.size() > 0) {
      for (Job__c job : queryJobs) {
        Job__c newJob = new Job__c();
        newJob.Record_Id__c = job.Id;
        newJob.Account_Name__c = job.Account_Name__c;
        newJob.Account_Name_Internal__c = job.Account_Name__r.Name;
        newJob.Active__c = job.Active__c;
        newJob.Description__c = job.Description__c;
        newJob.Name = job.Name;
        newJob.Type__c = job.Type__c;
        newJob.Standort__c = job.Standort__c;
        newJob.CreatedDate = job.CreatedDate;
        Decimal distDecimal = 0;
        Location locJob = Location.newInstance(
          job.Billing_Latitude__c,
          job.Billing_Longitude__c
        );
        Location locApplicant = Location.newInstance(
          account[0].BillingLatitude,
          account[0].BillingLongitude
        );
        Double dist = Location.getDistance(locJob, locApplicant, 'km');
        if (dist != null) {
          distDecimal = Decimal.valueOf(dist).setScale(2);
        }
        newJob.Distance_Job__c = String.valueOf(distDecimal);
        resultJobs.add(newJob);
      }
    }
    return resultJobs;
  }

  @AuraEnabled(Cacheable=true)
  public static List<Account> getAccounts(String filters) {
    Id applicantRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get('Fluchtling')
      .getRecordTypeId();

    String recordId, key, whereClause = '';
    String orderByClause = ' ORDER BY Name';
    Decimal maxDistance;
    String[] categories, owners = new List<String>{};
    String[] criteria = new List<String>{};
    Job__c[] job;
    List<Account> queryAccounts = new List<Account>();
    List<Account> resultAccounts = new List<Account>();
    List<Id> accountIdsWithMatch = new List<Id>();
    if (!String.isEmpty(filters)) {
      Filters accountFilters = (Filters) JSON.deserializeStrict(
        filters,
        jobMatcherController.Filters.class
      );
      recordId = accountFilters.recordId;
      job = [
        SELECT
          Job__c.Name,
          Type__c,
          Active__c,
          Standort__c,
          Description__c,
          Anzahl_Bewerber__c,
          Account_Name__r.Name,
          Billing_City__c,
          Billing_Street__c,
          Billing_Zip_Postal_Code__c,
          Billing_Latitude__c,
          Billing_Longitude__c
        FROM Job__c
        WHERE Id = :recordId
        LIMIT 1
      ];
      if (!String.isEmpty(accountFilters.searchKey)) {
        key = '\'' + accountFilters.searchKey + '\'';
        String searchquery =
          'FIND ' +
          key +
          ' IN ALL FIELDS RETURNING Account(Id)';
        List<List<sObject>> searchList = search.query(searchquery);
        Account[] accountsWithMatch = (Account[]) searchList[0];
        for (Account j : accountsWithMatch) {
          accountIdsWithMatch.add(j.Id);
        }
        if (accountIdsWithMatch.size() > 0) {
          criteria.add('Id IN :accountIdsWithMatch');
        }
      }
      if (accountFilters.maxDistance > 0) {
        maxDistance = accountFilters.maxDistance;
        criteria.add(
          'DISTANCE(BillingAddress, GEOLOCATION(' +
          job[0].Billing_Latitude__c +
          ',' +
          job[0].Billing_Longitude__c +
          '), \'km\') < ' +
          maxDistance
        );
        orderByClause =
          ' ORDER BY DISTANCE(BillingAddress, GEOLOCATION(' +
          job[0].Billing_Latitude__c +
          ',' +
          job[0].Billing_Longitude__c +
          '), \'km\') ASC';
      }
      if (accountFilters.categories.size() > 0) {
        categories = accountFilters.categories;
        boolean hasCondition = false;
        String stellenvermittlungQuery = '';
        if (!categories.isempty()) {
          hasCondition = true;
          stellenvermittlungQuery += '(\'' + categories[0] + '\'';
          categories.remove(0);
        }
        while (!categories.isempty()) {
          stellenvermittlungQuery += ',\'' + categories[0] + '\'';
          categories.remove(0);
        }
        if (hasCondition)
          stellenvermittlungQuery += ')';
        criteria.add(
          'Stellenvermittlung__pc INCLUDES ' + stellenvermittlungQuery
        );
      }
      if (accountFilters.owners != null) {
        owners = accountFilters.owners;
        criteria.add('OwnerId IN :owners');
      }
      if (criteria.size() > 0) {
        whereClause =
          'WHERE (NOT Im_Moment_nicht_auf_Arbeitssuche__pc = TRUE) AND (NOT LastName like \'Anonym%\') AND ' +
          String.join(criteria, ' AND ');
      }
    }

    String query =
      'SELECT FirstName, LastName, Sprachniveau__pc, ' +
      'Stellenvermittlung__pc, Berufswunsch__pc, BillingLatitude, BillingLongitude' +
      ' FROM Account ' +
      whereClause +
      orderByClause;
    queryAccounts = Database.query(query);
    if (queryAccounts.size() > 0) {
      for (Account account : queryAccounts) {
        Account newAccount = new Account();
        newAccount.Record_Id__c = account.Id;
        newAccount.FirstName = account.FirstName;
        newAccount.LastName = account.LastName;
        newAccount.Sprachniveau__pc = account.Sprachniveau__pc;
        newAccount.Stellenvermittlung__pc = account.Stellenvermittlung__pc;
        newAccount.Berufswunsch__pc = account.Berufswunsch__pc;
        Decimal distDecimal = 0;
        Location locJob = Location.newInstance(
          job[0].Billing_Latitude__c,
          job[0].Billing_Longitude__c
        );
        Location locApplicant = Location.newInstance(
          account.BillingLatitude,
          account.BillingLongitude
        );
        Double dist = Location.getDistance(locApplicant, locJob, 'km');
        if (dist != null) {
          distDecimal = Decimal.valueOf(dist).setScale(2);
        }
        newAccount.Distance_Job__c = String.valueOf(distDecimal);
        resultAccounts.add(newAccount);
      }
    }
    return resultAccounts;
  }

  @AuraEnabled(Cacheable=true)
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
    String origin = '';
    if (applicant[0].BillingStreet != null) {
      origin += applicant[0].BillingStreet + '+';
    }
    if (applicant[0].BillingPostalCode != null) {
      origin += applicant[0].BillingPostalCode + '+';
    }
    if (applicant[0].BillingCity != null) {
      origin += applicant[0].BillingCity;
    }
    String destination = '';
    if (jobs[0].Billing_Street__c != null) {
      destination += jobs[0].Billing_Street__c + '+';
    }
    if (jobs[0].Billing_Zip_Postal_Code__c != null) {
      destination += jobs[0].Billing_Zip_Postal_Code__c + '+';
    }
    if (jobs[0].Billing_City__c != null) {
      destination += jobs[0].Billing_City__c;
    }
    String googleMapURL =
      'https://www.google.com/maps/dir/?api=1&origin=' +
      EncodingUtil.urlEncode(origin, 'UTF-8') +
      '&destination=' +
      EncodingUtil.urlEncode(destination, 'UTF-8') +
      '&travelmode=transit';
    return googleMapURL;
  }
}
