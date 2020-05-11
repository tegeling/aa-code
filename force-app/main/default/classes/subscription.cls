global class subscription implements Messaging.inboundEmailHandler {
  global Messaging.InboundEmailResult handleInboundEmail(
    Messaging.InboundEmail email,
    Messaging.InboundEnvelope env
  ) {
    // Create an inboundEmailResult object for returning
    // the result of the email service.
    Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();

    // Create contact and lead lists to hold all the updated records.
    List<Account> la = new List<Account>();
    List<Contact> lc = new List<contact>();
    List<Lead> ll = new List<lead>();

    // Convert the subject line to lower case so the program can match on lower case.
    String mySubjectAll = email.subject.toLowerCase();
    String mySubject = mySubjectAll.left(255);

    try {
      // Look up all personaccounts with a matching email address.
      for (Account a : [
        SELECT
          Id,
          Name,
          PersonEmail,
          PersonHasOptedOutOfEmail,
          Subscription_Subject__pc
        FROM Account
        WHERE PersonEmail = :env.fromAddress
        LIMIT 100
      ]) {
        // Add all the matching personaccount into the list.
        a.Subscription_Subject__pc = mySubject;
        la.add(a);
        // Update all of the personaccount records.
        update lc;
      }
    } catch (System.QueryException e) {
      System.debug('PersonAccount Query Issue: ' + e);
    }

    try {
      // Look up all contacts with a matching email address.
      for (Contact c : [
        SELECT Id, Name, Email, HasOptedOutOfEmail, Subscription_Subject__c
        FROM Contact
        WHERE Email = :env.fromAddress
        LIMIT 100
      ]) {
        // Add all the matching contacts into the list.
        c.Subscription_Subject__c = mySubject;
        lc.add(c);
        // Update all of the contact records.
        update lc;
      }
    } catch (System.QueryException e) {
      System.debug('Contact Query Issue: ' + e);
    }

    try {
      // Look up all leads matching the email address.
      for (Lead l : [
        SELECT Id, Name, Email, HasOptedOutOfEmail, Subscription_Subject__c
        FROM Lead
        WHERE Email = :env.fromAddress AND isConverted = false
        LIMIT 100
      ]) {
        // Add all the leads to the list.
        l.Subscription_Subject__c = mySubject;
        ll.add(l);

        System.debug('Lead Object: ' + l);
      }
      // Update all lead records in the query.
      update ll;
    } catch (System.QueryException e) {
      System.debug('Lead Query Issue: ' + e);
    }

    // Return True and exit.
    // True confirms program is complete
    result.success = true;
    return result;
  }
}