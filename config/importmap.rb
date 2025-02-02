# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "chart.js", to: "https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.js"
pin "chartjs-chart-wordcloud", to: "https://cdn.jsdelivr.net/npm/chartjs-chart-wordcloud@4.4.4/build/index.umd.min.js"
pin_all_from "app/javascript/controllers", under: "controllers"