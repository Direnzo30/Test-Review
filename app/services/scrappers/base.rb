require 'selenium-webdriver'

module Scrappers
  class Base
    attr_accessor :driver, :url, :scrapping_wait

    SELENIUM_TIME_OUT = 10

    def initialize(url)
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--headless') # Run browser in headless mode
      @driver = Selenium::WebDriver.for :chrome, options: options
      @scrapping_wait = Selenium::WebDriver::Wait.new(timeout: SELENIUM_TIME_OUT)
      @url = url
    end
  end
end