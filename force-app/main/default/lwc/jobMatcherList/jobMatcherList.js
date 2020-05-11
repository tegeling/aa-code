import { LightningElement, wire, track, api } from "lwc";
import { CurrentPageReference, NavigationMixin } from "lightning/navigation";
import getJobs from "@salesforce/apex/jobMatcherController.getJobs";
import getGoogleMapsURL from "@salesforce/apex/jobMatcherController.getGoogleMapsURL";

import { registerListener, unregisterAllListeners } from "c/pubsub";

const actions = [
  { label: "View", name: "view" },
  { label: "Google Maps", name: "maps" }
];

const columns = [
  { label: "Job Name", fieldName: "Name", type: "text" },
  {
    label: "Account Name",
    fieldName: "Account_Name_Internal__c",
    type: "text"
  },
  { label: "Job Description", fieldName: "Description__c", type: "text" },
  { label: "Type", fieldName: "Type__c", type: "text" },
  { label: "Entfernung (km)", fieldName: "Distance_Job__c", type: "text" },
  { label: "Created Date", fieldName: "CreatedDate", type: "date" },
  {
    type: "action",
    typeAttributes: { rowActions: actions }
  }
];

export default class JobMatcherList extends NavigationMixin(LightningElement) {
  @api recordId;

  @track filters = "{}";

  @track jobs = [];
  @track error;
  @track title = "Trefferliste Jobs";

  @wire(CurrentPageReference) pageRef;
  @track columns = columns;
  @track record = {};

  @wire(getJobs, { filters: "$filters" })
  wiredJobs({ error, data }) {
    if (data) {
      this.jobs = data;
      this.error = undefined;
      if (data.length > 0) {
        this.title = "Trefferliste Jobs (" + data.length + " Treffer)";
        console.log("#### job data:" + JSON.stringify(data));
      } else {
        this.title = "Trefferliste Jobs (0 Treffer - Filter anpassen)";
      }
    } else if (error) {
      this.error = error;
      this.jobs = undefined;
    }
  }

  connectedCallback() {
    registerListener("filterChange", this.handleFilterChange, this);
  }

  disconnectedCallback() {
    unregisterAllListeners(this);
  }

  handleFilterChange(filters) {
    this.filters = JSON.stringify(filters);
  }

  handleRowAction(event) {
    const actionName = event.detail.action.name;
    const row = event.detail.row;
    switch (actionName) {
      case "maps":
        this.showMaps(row);
        break;
      case "view":
        this.showRowDetails(row);
        break;
      default:
    }
  }

  showRowDetails(row) {
    this.record = row;
    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        recordId: this.record.Record_Id__c,
        objectApiName: "Job__c",
        actionName: "view"
      }
    });
  }

  showMaps(row) {
    this.record = row;
    let mapUrl = "https://www.google.com/maps/dir/?api=1";
    getGoogleMapsURL({
      jobId: this.record.Record_Id__c,
      applicantId: this.recordId
    })
      .then((result) => {
        mapUrl = result;
        this.error = undefined;
      })
      .catch((error) => {
        this.error = error;
      });
    this[NavigationMixin.Navigate]({
      type: "standard__webPage",
      attributes: {
        url: mapUrl
      }
    });
  }
}