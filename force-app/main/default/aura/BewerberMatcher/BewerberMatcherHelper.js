({
  getApplicants: function (component) {
    var action = component.get("c.getBewerber");
    var maxDist;
    maxDist = parseInt(component.get("v.maxDistance"));
    if (isNaN(maxDist)) {
      maxDist = 0;
    }

    var selectedOwners = component.find("ownerAlias");
    var listOwners = [];
    listOwners = selectedOwners.get("v.value").split(";");

    action.setParams({
      recordId: component.get("v.recordId"),
      maxDistance: maxDist,
      ownerIds: listOwners
    });

    action.setCallback(this, function (response) {
      var relatedApplicants = response.getReturnValue();
      component.set("v.applicant", relatedApplicants);
    });
    $A.enqueueAction(action);
  },

  getActiveUsers: function (component) {
    var actionUser = component.get("c.getActiveUsers");
    var onlyActiveUsers = component.get("v.onlyActiveUsers");
    actionUser.setParams({
      activeUsers: onlyActiveUsers
    });

    actionUser.setCallback(this, function (response) {
      var activeUsersResult = response.getReturnValue();
      var options = [];
      var obj;
      for (obj in activeUsersResult) {
        var activeUser = activeUsersResult[obj];
        var userLabel =
          activeUser.Alias +
          " - " +
          activeUser.FirstName +
          " " +
          activeUser.LastName;
        options.push({
          class: "optionClass",
          value: activeUser.Id,
          label: userLabel
        });
      }
      component.find("ownerAlias").set("v.options", options);
    });
    $A.enqueueAction(actionUser);
  },

  openGoogleMaps: function (component, jobId, applicantId) {
    var urlEvt = $A.get("e.force:navigateToURL");
    var actionUser = component.get("c.getGoogleMapsURL");
    var googleMapsURL = "https://www.google.com/maps/dir/?api=1";
    actionUser.setParams({
      jobId: jobId,
      applicantId: applicantId
    });

    actionUser.setCallback(this, function (response) {
      googleMapsURL = response.getReturnValue();
      urlEvt.setParams({
        url: googleMapsURL
      });
      urlEvt.fire();
    });
    $A.enqueueAction(actionUser);
  }
});
