({
  doInit: function (component, event, helper) {
    var actions = [
      { label: "View", name: "view" },
      { label: "Google Maps", name: "map" }
    ];
    component.set("v.applicantColumns", [
      { label: "First Name", fieldName: "FirstName", type: "text" },
      { label: "Last Name", fieldName: "LastName", type: "text" },
      { label: "City", fieldName: "BillingCity", type: "text" },
      { label: "Distance", fieldName: "Distance_Job__c", type: "text" },
      { label: "Berufswunsch", fieldName: "Berufswunsch__c", type: "text" },
      {
        label: "Deutschkenntnisse",
        fieldName: "Deutschkenntnisse__c",
        type: "text"
      },
      { type: "action", typeAttributes: { rowActions: actions } }
    ]);

    helper.getApplicants(component);
    helper.getActiveUsers(component);
  },

  onOwnerSelectChange: function (component, event, helper) {
    helper.getApplicants(component);
  },

  onActiveUsersCheck: function (component, event, helper) {
    helper.getActiveUsers(component);
  },

  navToRecord: function (component, event, helper) {
    var navEvt = $A.get("e.force:navigateToSObject");
    var idOfJob = event.target.id;

    navEvt.setParams({
      recordId: idOfJob,
      slideDevName: "related"
    });
    navEvt.fire();
  },

  handleRowAction: function (component, event, helper) {
    var action = event.getParam("action");
    var row = event.getParam("row");
    var navEvt = $A.get("e.force:navigateToSObject");
    var applicantId = row.Record_Id__c;
    var jobId = component.get("v.recordId");
    switch (action.name) {
      case "view":
        navEvt.setParams({
          recordId: applicantId,
          slideDevName: "related"
        });
        navEvt.fire();
        break;
      case "map":
        helper.openGoogleMaps(component, jobId, applicantId);
        break;
    }
  }
});
