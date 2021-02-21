public inherited sharing class DuplicatesHelper {
  private List<String> matchedContacts;
  private List<String> matchedAccounts;

  public DuplicatesHelper(AccountRequest request) {
    List<String> matchedAccounts = new List<String>();
    Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
      .get(request.accountRecordType)
      .getRecordTypeId();

    // create new Account
    Account newAccount = new Account();
    newAccount.Name = request.accountName;
    newAccount.RecordTypeId = accountRecordTypeId;

    List<Account> newAccountList = new List<Account>();
    newAccountList.add(newAccount);

    // check duplicates
    List<Datacloud.FindDuplicatesResult> duplicates = Datacloud.FindDuplicates.findDuplicates(
      newAccountList
    );
    for (Datacloud.FindDuplicatesResult findDupeResult : duplicates) {
      for (
        Datacloud.DuplicateResult dupeResult : findDupeResult.getDuplicateResults()
      ) {
        for (Datacloud.MatchResult matchResult : dupeResult.getMatchResults()) {
          for (
            Datacloud.MatchRecord matchRecord : matchResult.getMatchRecords()
          ) {
            matchedAccounts.add(matchRecord.getRecord().Id);
          }
        }
      }
    }
  }

  public DuplicatesHelper(ContactRequest request) {
    List<String> matchedContacts = new List<String>();
    Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
      .get('Allgemeiner_Kontakt')
      .getRecordTypeId();

    // create new Contact
    Contact newContact = new Contact();
    newContact.FirstName = request.firstName;
    newContact.LastName = request.lastName;
    newContact.Email = request.email;
    newContact.AccountId = request.accountId;
    newContact.Group_Email__c = request.isGroupEmail;
    newContact.RecordTypeId = contactRecordTypeId;

    List<Contact> newContactList = new List<Contact>();
    newContactList.add(newContact);

    // check duplicates
    List<Datacloud.FindDuplicatesResult> duplicates = Datacloud.FindDuplicates.findDuplicates(
      newContactList
    );
    for (Datacloud.FindDuplicatesResult findDupeResult : duplicates) {
      for (
        Datacloud.DuplicateResult dupeResult : findDupeResult.getDuplicateResults()
      ) {
        for (Datacloud.MatchResult matchResult : dupeResult.getMatchResults()) {
          for (
            Datacloud.MatchRecord matchRecord : matchResult.getMatchRecords()
          ) {
            matchedContacts.add(matchRecord.getRecord().Id);
          }
        }
      }
    }
  }

  public List<String> getMatchedContacts() {
    return matchedContacts;
  }

  public List<String> getMatchedAccounts() {
    return matchedAccounts;
  }

  public class ContactRequest {
    @InvocableVariable(
      label='First Name'
      description='First Name of the Contact'
      required=true
    )
    public String firstName;

    @InvocableVariable(
      label='Last Name'
      description='Last Name of the Contact'
      required=true
    )
    public String lastName;

    @InvocableVariable(
      label='Email'
      description='Email address of the Contact'
      required=true
    )
    public String email;

    @InvocableVariable(
      label='Is Group Email'
      description='True if Contact Email is a group address'
      required=true
    )
    public Boolean isGroupEmail;

    @InvocableVariable(
      label='Account Id'
      description='Contact belongs to this Account'
      required=true
    )
    public String accountId;

    @InvocableVariable(
      label='Record Type'
      description='Developer API Name of Contact record type'
      required=true
    )
    public String contactRecordType;
  }

  public class AccountRequest {
    @InvocableVariable(
      label='Account Name'
      description='Name of the Account'
      required=true
    )
    public String accountName;

    @InvocableVariable(
      label='Record Type'
      description='Developer API Name of Account record type'
      required=true
    )
    public String accountRecordType;
  }
}
