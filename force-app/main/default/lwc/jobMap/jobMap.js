import { LightningElement, api, track, wire } from "lwc";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

import BILLING_LAT from "@salesforce/schema/Job__c.Billing_Latitude__c";
import BILLING_LONG from "@salesforce/schema/Job__c.Billing_Longitude__c";
import NAME from "@salesforce/schema/Job__c.Name";

const fields = [BILLING_LAT, BILLING_LONG, NAME];

export default class JobMap extends LightningElement {
  @api recordId;

  @track zoomLevel = 16;

  @track markers = [];

  @track error;

  @wire(getRecord, { recordId: "$recordId", fields })
  wiredRecord({ error, data }) {
    if (data) {
      this.markers = [];
      this.error = undefined;
      const lat = getFieldValue(data, BILLING_LAT);
      if (lat) {
        this.markers = [
          {
            location: {
              Latitude: getFieldValue(data, BILLING_LAT),
              Longitude: getFieldValue(data, BILLING_LONG)
            },
            title: getFieldValue(data, NAME),
            description:
              '<a href="https://www.google.com/maps/search/?api=1&query=' +
              getFieldValue(data, BILLING_LAT) +
              "," +
              getFieldValue(data, BILLING_LONG) +
              '" target="_blank">in Google Maps ansehen</a>'
          }
        ];
      }
    } else if (error) {
      this.markers = [];
      this.error = error;
    }
  }
}