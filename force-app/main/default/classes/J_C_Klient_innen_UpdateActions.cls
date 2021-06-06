public without sharing class J_C_Klient_innen_UpdateActions {
  public static void setChatterFollower(
    List<J_C_Klient_innen_Update__c> newJ_C_Klient_innen_Update
  ) {
    // select active users with permission set ArrivalAid_Jobs_Careers
    PermissionSet[] permJ_C = [
      SELECT Id, Name
      FROM PermissionSet
      WHERE Name = 'ArrivalAid_Jobs_Careers'
    ];
    PermissionSetAssignment[] permAssignees = [
      SELECT AssigneeId, Id
      FROM PermissionSetAssignment
      WHERE PermissionSetId = :permJ_C[0].Id
    ];
    for (
      J_C_Klient_innen_Update__c curJ_C_Klient_innen_Update : newJ_C_Klient_innen_Update
    ) {
      // set followers
      // public static ConnectApi.Subscription follow(String communityId, String userId, String subjectId)
      // userId - ID for the context user or the keyword me.
      // subjectId - ID of the user or record to follow.
      for (PermissionSetAssignment curAssignee : permAssignees) {
        ConnectApi.Subscription subscriptionToRecord = ConnectApi.ChatterUsers.follow(
          null,
          curAssignee.AssigneeId,
          curJ_C_Klient_innen_Update.Id
        );
      }
    }
  }
}
