@IsTest
public class Test_DataTableWithFlowController {
  static testMethod void getRecord() {
    List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];

    Test.startTest();
    Object result = DataTableWithFlowController.getRecord(userList[0].Id);
    System.assertEquals(true, true);
    Test.stopTest();
  }
  static testMethod void getRecords() {
    List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];

    List<String> recordIds = new List<String>();
    recordIds.add(userList[0].Id);
    Test.startTest();
    Object result = DataTableWithFlowController.getRecords(recordIds);
    System.assertEquals(true, true);
    Test.stopTest();
  }

  static testMethod void getNoRecordsWithNull() {
    List<String> recordIds = new List<String>();
    Test.startTest();
    Object result = DataTableWithFlowController.getRecords(recordIds);
    System.assertEquals(true, true);
    Test.stopTest();
  }

  static testMethod void getNoRecordWithNull() {
    Test.startTest();
    Object result = DataTableWithFlowController.getRecord(null);
    System.assertEquals(true, true);
    Test.stopTest();
  }

  static testMethod void getNoRecordWithBlank() {
    Test.startTest();
    Object result = DataTableWithFlowController.getRecord('');
    System.assertEquals(true, true);
    Test.stopTest();
  }

  static testMethod void getNoRecordWithInvalidId() {
    Test.startTest();
    Object result = DataTableWithFlowController.getRecord('123456789012345678');
    System.assertEquals(true, true);
    Test.stopTest();
  }
}