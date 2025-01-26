import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["spinner"];

  connect(){
  }

  loadMore(event) {
    const button = event.currentTarget;
    const nextPageUrl = button.dataset.paginationNextPageUrl;
    if (!nextPageUrl) return;
    this.spinnerTarget.classList.remove("d-none");
    fetch(nextPageUrl, {
      headers: {
        "Accept": "text/vnd.turbo-stream.html",
      },
    })
    .then(response => response.text())
    .then(turboStream => {
      document.body.insertAdjacentHTML("beforeend", turboStream);
      this.spinnerTarget.classList.add("d-none");
    })
    .catch(error => {
      console.error('Error fetching chart data:', error);
    });
  }
}
