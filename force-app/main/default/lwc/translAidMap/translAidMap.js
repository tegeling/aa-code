import { LightningElement, wire } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import { registerListener, unregisterAllListeners } from "c/pubsub";
import getLocations from "@salesforce/apex/TranslAidMapController.getLocations";

export default class TranslAidMap extends LightningElement {
  @wire(CurrentPageReference) pageRef;

  mapMarkers = undefined;
  error;
  recordIds = "";

  connectedCallback() {
    // subscribe to searchKeyChange event
    registerListener("search_key_change", this.handleSearchKeyChange, this);
  }

  disconnectedCallback() {
    // unsubscribe from searchKeyChange event
    unregisterAllListeners(this);
  }

  handleSearchKeyChange(searchKey) {
    this.recordIds = searchKey;
    getLocations({ recordIds: this.recordIds })
      .then((result) => {
        this.mapMarkers = result;
      })
      .catch((error) => {
        this.error = error;
      });
  }
}
