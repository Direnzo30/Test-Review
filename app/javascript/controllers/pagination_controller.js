import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["listings"];

  connect(){
  }

  loadMore(event) {
    const button = event.currentTarget;
    const nextPageUrl = button.dataset.paginationNextPageUrl;

    if (!nextPageUrl) return;

    fetch(nextPageUrl, {
      headers: {
        "Accept": "text/vnd.turbo-stream.html",
      },
    })
    .then(response => response.text())
    .then(turboStream => {
      console.log(turboStream)
      document.body.insertAdjacentHTML("beforeend", turboStream);
    })
    .catch(error => {
      console.error('Error fetching chart data:', error);
    });
  }
}
