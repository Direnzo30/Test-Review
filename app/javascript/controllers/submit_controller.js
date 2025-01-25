import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="submit"
export default class extends Controller {
  static targets = ["spinner"];

  submit(event) {
    const button = event.currentTarget;
    this.spinnerTarget.classList.remove("d-none");
  }
}

