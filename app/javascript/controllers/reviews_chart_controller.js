import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="reviews-chart"
export default class extends Controller {
  static targets = ["selectedYear"]
  static values = { reviews: Object, year: Number, listingId: Number }

  connect() {
    this.createChart();
  }

  createChart() {
    const ctx = document.getElementById('bar-chart').getContext('2d');
    this.chart = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: Object.keys(this.reviewsValue),
        datasets: [{
          label: `# Reviews for year ${this.yearValue}`,
          data: Object.values(this.reviewsValue),
          backgroundColor: 'rgba(255, 99, 132, 0.2)',
          borderColor: 'rgba(255, 99, 132, 1)',
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        scales: {
          y: {
            beginAtZero: true
          }
        }
      }
    });
  }

  reload() {
    const year = this.selectedYearTarget.value;
    const listingId = this.listingIdValue;

    fetch(`/listings/${listingId}?year=${year}`, {
      headers: {
        "Accept": "text/vnd.turbo-stream.html",
      },
    })
    .then(response => response.text())
    .then(turboStream => {
      document.body.insertAdjacentHTML("beforeend", turboStream);
    })
    .catch(error => {
      console.error('Error fetching chart data:', error);
    });
  }
}
