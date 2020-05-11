// Used
import { LightningElement, api, wire, track } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import { getPicklistValues } from "lightning/uiObjectInfoApi";
import CATEGORY_FIELD from "@salesforce/schema/Job__c.Type__c";
import getActiveAccountOwners from "@salesforce/apex/jobMatcherController.getActiveAccountOwners";
import { getRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import UserId from "@salesforce/user/Id";

import { fireEvent } from "c/pubsub";

const DELAY = 350;

const JOBFIELDS = [
  "Job__c.Name",
  "Job__c.Type__c",
  "Job__c.Account_Name__r.OwnerId"
];

export default class ApplicantMatcherFilter extends LightningElement {
  @api recordId;

  @track categoryValues = [];
  @track categoryOptions = [];

  @track ownerValues = [];
  @track ownerOptions = [];

  searchKey = "";
  maxDistance = 100;

  @track filters = {
    recordId: this.recordId,
    searchKey: "",
    maxDistance: 5
  };

  @wire(CurrentPageReference) pageRef;

  @wire(getPicklistValues, {
    recordTypeId: "012000000000000AAA",
    fieldApiName: CATEGORY_FIELD
  })
  fetchedCategories({ error, data }) {
    if (data) {
      //this.fetchedCategories = data;
      this.categoryOptions = [];

      let categoryArrayLength = data.values.length;
      for (let i = 0; i < categoryArrayLength; i++) {
        this.categoryOptions[i] = {};
        this.categoryOptions[i].label = data.values[i].label;
        this.categoryOptions[i].value = data.values[i].value;
      }
    } else if (error) {
      console.log(error);
    }
  }

  @wire(getRecord, { recordId: "$recordId", fields: JOBFIELDS })
  job({ error, data }) {
    if (error) {
      let message = "Unknown error";
      if (Array.isArray(error.body)) {
        message = error.body.map((e) => e.message).join(", ");
      } else if (typeof error.body.message === "string") {
        message = error.body.message;
      }
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Error loading contact",
          message,
          variant: "error"
        })
      );
    } else if (data) {
      this.categoryValues = data.fields.Type__c.value.split(";");
      this.ownerValues = UserId;
      this.filters.categories = this.categoryValues;
      this.filters.owners = [];
      this.filters.owners.push(UserId);
      this.filters.recordId = this.recordId;
      fireEvent(this.pageRef, "applicantFilterChange", this.filters);
    }
  }

  @wire(getActiveAccountOwners) fetchedOwners({ error, data }) {
    if (data) {
      //this.fetchedOwners = data;
      this.ownerOptions = [];
      let ownerArrayLength = data.length;
      for (let i = 0; i < ownerArrayLength; i++) {
        let currentOwner = data[i];
        this.ownerOptions[i] = {};
        let ownerLabel = currentOwner.Name;
        let ownerValue = currentOwner.Id;
        this.ownerOptions[i].label = ownerLabel;
        this.ownerOptions[i].value = ownerValue;
      }
    } else if (error) {
      console.log(error);
    }
  }

  handleSearchKeyChange(event) {
    this.filters.searchKey = event.target.value;
    this.filters.recordId = this.recordId;
    this.delayedFireFilterChangeEvent();
  }

  handleDistanceChange(event) {
    const distance = event.target.value;
    this.filters.recordId = this.recordId;
    this.filters.maxDistance = distance;
    this.delayedFireFilterChangeEvent();
  }

  handleJobTypeCheckboxChange(event) {
    this.filters.recordId = this.recordId;
    if (!this.filters.categories) {
      this.filters.categories = event.detail.value;
    }
    this.filters.categories = event.detail.value;
    fireEvent(this.pageRef, "applicantFilterChange", this.filters);
  }

  handleOwnerCheckboxChange(event) {
    this.filters.recordId = this.recordId;
    if (!this.filters.owners) {
      this.filters.owners = event.detail.value;
    }
    this.filters.owners = event.detail.value;
    fireEvent(this.pageRef, "applicantFilterChange", this.filters);
  }

  delayedFireFilterChangeEvent() {
    // Debouncing this method: Do not actually fire the event as long as this function is
    // being called within a delay of DELAY. This is to avoid a very large number of Apex
    // method calls in components listening to this event.
    window.clearTimeout(this.delayTimeout);
    // eslint-disable-next-line @lwc/lwc/no-async-operation
    this.delayTimeout = setTimeout(() => {
      fireEvent(this.pageRef, "applicantFilterChange", this.filters);
    }, DELAY);
  }
}
