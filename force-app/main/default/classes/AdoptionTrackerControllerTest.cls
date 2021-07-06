@isTest
public class AdoptionTrackerControllerTest {
  /* 
        This test relies on the event-triggered Flow "Adoption Event" to create the adoption records. Else it will fail :-(
    */
  @isTest
  static void testPublishEvent() {
    Test.startTest();
    AdoptionTrackerController.publishEvent('My Feature', 'My Action');
    Test.stopTest();

    List<Adoption_Tracking__c> at = [
      SELECT Id, Name, Action__c
      FROM Adoption_Tracking__c
    ];
    system.assertEquals(1, at.size(), 'No Adoption Track records found');
    system.assertEquals(
      'My Feature',
      at[0].Name,
      'Adoption Tracking Feature not correct'
    );
    system.assertEquals(
      'My Action',
      at[0].Action__c,
      'Adoption Tracking Action not correct'
    );
  }
}
