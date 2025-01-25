import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="submit"
export default class extends Controller {
  static targets = ["spinner"];

  connect() {
    this.spinnerTarget.classList.add("d-none");
  }

  submit(event) {
    this.spinnerTarget.classList.remove("d-none");
  }
}

