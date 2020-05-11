({
  doInit: function (component, event, helper) {
    var action = component.get("c.getRelatedJobs");

    var maxDist;
    maxDist = parseInt(component.get("v.maxDistance"));
    if (isNaN(maxDist)) {
      maxDist = 0;
    }

    action.setParams({
      recordId: component.get("v.recordId"),
      maxDistance: maxDist
    });

    action.setCallback(this, function (response) {
      var relatedJobs = response.getReturnValue();
      component.set("v.relatedJobs", relatedJobs);
    });
    $A.enqueueAction(action);
  },

  navToRecord: function (component, event, helper) {
    var navEvt = $A.get("e.force:navigateToSObject");
    var idOfJob = event.target.id;

    navEvt.setParams({
      recordId: idOfJob,
      slideDevName: "related"
    });
    navEvt.fire();
  }
});