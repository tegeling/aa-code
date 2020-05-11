({
  doInit: function (component, event, helper) {
    var actions = [
      { label: "View", name: "view" },
      { label: "Google Maps", name: "map" }
    ];
    component.set("v.jobColumns", [
      { label: "Job Name", fieldName: "Name", type: "text" },
      { label: "Description", fieldName: "Description__c", type: "text" },
      { label: "Distance", fieldName: "Distance_Job__c", type: "text" },
      { type: "action", typeAttributes: { rowActions: actions } }
    ]);

    helper.getJobs(component);
    helper.getActiveUsers(component);
  },

  onOwnerSelectChange: function (component, event, helper) {
    helper.getJobs(component);
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
    var jobId = row.Record_Id__c;
    var applicantId = component.get("v.recordId");
    switch (action.name) {
      case "view":
        navEvt.setParams({
          recordId: jobId,
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