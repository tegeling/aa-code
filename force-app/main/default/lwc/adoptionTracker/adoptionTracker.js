import { LightningElement, api } from "lwc";
import publishEvent from "@salesforce/apex/AdoptionTrackerController.publishEvent";

export default class AdoptionTracker extends LightningElement {
  @api action;
  @api feature;

  connectedCallback() {
    if (!this.action && !this.feature) {
      console.log("### ADOPTION ### Action & Feature not set, aborting");
      return;
    }
    publishEvent({ feature: this.feature, action: this.action }).catch(
      (error) => {
        console.log("### ADOPTION ### Error publishing event: " + error);
      }
    );
  }
}
