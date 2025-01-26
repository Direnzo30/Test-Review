import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="words-cloud"
export default class extends Controller {
  static values = { words: Array }

  connect() {
    this.renderWordCloud()
  }

  renderWordCloud() {
    const words = this.wordsValue;
    const ctx = document.getElementById('words-cloud').getContext('2d');

    new Chart(ctx, {
      type: "wordCloud",
      data: {
        labels: words.map(word => word.text),
        datasets: [
          {
            label: "Must common words during reviews",
            data: words.map(word => word.count),
            color: words.map(() => `#${Math.floor(Math.random() * 16777215).toString(16)}`) // Random colors
          }
        ]
      },
      options: {
        plugins: {
          legend: {
            display: false
          }
        }
      }
    });
  }
}
