// Used
import { LightningElement, wire, track, api } from "lwc";
import { CurrentPageReference, NavigationMixin } from "lightning/navigation";
import getAccounts from "@salesforce/apex/jobMatcherController.getAccounts";
import getGoogleMapsURL from "@salesforce/apex/jobMatcherController.getGoogleMapsURL";

/** Pub-sub mechanism for sibling component communication. */
import { registerListener, unregisterAllListeners } from "c/pubsub";

const actions = [
  { label: "View", name: "view" },
  { label: "Google Maps", name: "maps" }
];

const columns = [
  { label: "First Name", fieldName: "FirstName" },
  { label: "Last Name", fieldName: "LastName" },
  { label: "Berufswunsch", fieldName: "Berufswunsch__pc", type: "text" },
  {
    label: "Deutschkenntnisse",
    fieldName: "Deutschkenntnisse__c",
    type: "text"
  },
  {
    label: "Stellenvermittlung",
    fieldName: "Stellenvermittlung_neu__c",
    type: "text"
  },
  { label: "Entfernung (km)", fieldName: "Distance_Job__c", type: "text" },
  {
    type: "action",
    typeAttributes: { rowActions: actions }
  }
];

export default class ApplicantMatcherList extends NavigationMixin(
  LightningElement
) {
  @api recordId;

  @track filters = "{}";

  @track accounts = [];
  @track error;
  @track title = "Trefferliste Bewerber";

  @wire(CurrentPageReference) pageRef;
  @track columns = columns;
  @track record = {};

  @wire(getAccounts, { filters: "$filters" })
  wiredJobs({ error, data }) {
    if (data) {
      this.accounts = data;
      this.error = undefined;
      if (data.length > 0) {
        this.title = "Trefferliste Bewerber (" + data.length + " Treffer)";
      } else {
        this.title = "Trefferliste Bewerber (0 Treffer - Filter anpassen)";
      }
    } else if (error) {
      this.error = error;
      this.accounts = undefined;
    }
  }

  connectedCallback() {
    registerListener(
      "applicantFilterChange",
      this.handleApplicantFilterChange,
      this
    );
  }

  disconnectedCallback() {
    unregisterAllListeners(this);
  }

  handleApplicantFilterChange(filters) {
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
        objectApiName: "Account",
        actionName: "view"
      }
    });
  }

  showMaps(row) {
    this.record = row;
    let mapUrl = "https://www.google.com/maps/dir/?api=1";
    console.log("#### Open Google Maps");
    getGoogleMapsURL({
      jobId: this.recordId,
      applicantId: this.record.Record_Id__c
    })
      .then((result) => {
        console.log("#### URL: " + result);
        mapUrl = result;
        this.error = undefined;
        this[NavigationMixin.Navigate]({
          type: "standard__webPage",
          attributes: {
            url: mapUrl
          }
        });
      })
      .catch((error) => {
        console.log("#### URL error");
        this.error = error;
      });
  }
}
