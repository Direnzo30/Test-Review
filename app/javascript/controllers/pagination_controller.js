import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["listings"];

  connect(){
  }

  loadMore(event) {
    const button = event.currentTarget;
    const nextPageUrl = button.dataset.paginationNextPageUrl;

    if (!nextPageUrl) return;

    button.classList.add("loading");

    fetch(nextPageUrl, { headers: { Accept: "text/vnd.turbo-stream.html" } })
      .catch((error) => console.error("Error loading more listings:", error))
      .finally(() => button.classList.remove("loading"));
  }
}
