# Note: Light version for the Airbnb scrapper, Just for extracting the Property name
module Scrappers
  class AirbnbLight < Scrappers::Base

    TRANSLATION_MODAL = 'header[data-testid="translation-announce-modal"]'.freeze
    CLOSE_TRANSLATION_MODAL = 'div[role="dialog"] button[aria-label="Close"]'.freeze
    PROPERTY_NAME_CONTAINER = 'div[data-section-id="TITLE_DEFAULT"] h1.hpipapi'.freeze

    def initialize(url:, user_id: nil)
      @user_id = user_id
      @property_name = ""
      @listing = nil
      super(url)
    end

    def scrap
      begin
        driver.get(url)
        dismiss_translation_modal
        property_name_flow
        store_listing

        return @listing
      rescue => e
        puts "#{e}"
        return nil
      ensure
        driver.quit
      end
    end

    private
    # Step 1
    def dismiss_translation_modal
      begin
        translation_modal = scrapping_wait.until do
          driver.find_element(css: TRANSLATION_MODAL)
        end
        close_button = scrapping_wait.until do
          driver.find_element(css: CLOSE_TRANSLATION_MODAL)
        end
        close_button.click
        # let the page load for be interactive for other flows
        sleep 1
      rescue
        # This means the modal was nerver triggered
      end
    end

    # Step 2
    def property_name_flow
      @property_name = scrapping_wait.until do
        driver.find_element(css: PROPERTY_NAME_CONTAINER).text
      end
    end

    def store_listing
      @listing = Listing.new.tap do |listing|
        listing.user_id = @user_id
        listing.name = @property_name
        listing.url = @url
        listing.full_scrapped = false
      end
      @listing.save!
    end
  end
end
