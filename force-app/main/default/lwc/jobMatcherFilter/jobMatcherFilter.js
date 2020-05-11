/* eslint-disable no-console */
import { LightningElement, api, wire, track } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import { getPicklistValues } from "lightning/uiObjectInfoApi";
import CATEGORY_FIELD from "@salesforce/schema/Job__c.Type__c";
import { getRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

/** Pub-sub mechanism for sibling component communication. */
import { fireEvent } from "c/pubsub";

/** The delay used when debouncing event handlers before firing the event. */
const DELAY = 350;

const ACCOUNTFIELDS = [
  "Account.Name",
  "Account.Stellenvermittlung_neu__c",
  "Account.OwnerId"
];

export default class JobMatcherFilter extends LightningElement {
  @api recordId;

  @track categoryValues = [];
  @track categoryOptions = [];

  @wire(getRecord, { recordId: "$recordId", fields: ACCOUNTFIELDS })
  account({ error, data }) {
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
      this.categoryValues = data.fields.Stellenvermittlung_neu__c.value.split(
        ";"
      );
      this.filters.categories = this.categoryValues;
      this.filters.recordId = this.recordId;
      fireEvent(this.pageRef, "filterChange", this.filters);
    }
  }

  searchKey = "";
  maxDistance = 100;

  @track filters = {
    recordId: this.recordId,
    searchKey: "",
    createdDate: "",
    maxDistance: 5
  };

  @wire(CurrentPageReference) pageRef;

  @wire(getPicklistValues, {
    recordTypeId: "012000000000000AAA",
    fieldApiName: CATEGORY_FIELD
  })
  fetchedCategories({ error, data }) {
    if (data) {
      this.fetchedCategories = data;
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

  handleSearchKeyChange(event) {
    this.filters.searchKey = event.target.value;
    this.filters.recordId = this.recordId;
    this.delayedFireFilterChangeEvent();
  }

  handleCreatedDateChange(event) {
    this.filters.createdDate = event.target.value;
    console.log("#### createdDate:" + this.filters.createdDate);
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
    fireEvent(this.pageRef, "filterChange", this.filters);
  }

  delayedFireFilterChangeEvent() {
    // Debouncing this method: Do not actually fire the event as long as this function is
    // being called within a delay of DELAY. This is to avoid a very large number of Apex
    // method calls in components listening to this event.
    window.clearTimeout(this.delayTimeout);
    // eslint-disable-next-line @lwc/lwc/no-async-operation
    this.delayTimeout = setTimeout(() => {
      fireEvent(this.pageRef, "filterChange", this.filters);
    }, DELAY);
  }
}