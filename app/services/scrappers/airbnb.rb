module Scrappers
  class Airbnb < Scrappers::Base
    TRANSLATION_MODAL = 'header[data-testid="translation-announce-modal"]'.freeze
    CLOSE_TRANSLATION_MODAL = 'div[role="dialog"] button[aria-label="Close"]'.freeze
    PROPERTY_NAME_CONTAINER = 'div[data-section-id="TITLE_DEFAULT"] h1.hpipapi'.freeze
    REVIEWS_BUTTON_CONTAINER = 'button[data-testid="pdp-show-all-reviews-button"]'.freeze
    REVIEWS_AREA_SCROLL_CONTAINER = 'div[role="dialog"] ._17itzz4'.freeze
    SINGLE_REVIEW_CONTAINER = '[data-review-id]'.freeze
    NAME_CONTAINER = 'div:first-child h2'.freeze
    DATE_CONTAINER = 'div.s78n3tv.atm_c8_1w0928g.atm_g3_1dd5bz5.atm_cs_10d11i2.atm_9s_1txwivl.atm_h_1h6ojuz.dir.dir-ltr'.freeze
    REVIEW_TEXT_CONTAINER = 'span.l1h825yc.atm_kd_19r6f69_24z95b.atm_kd_19r6f69_1xbvphn_1oszvuo.dir.dir-ltr'.freeze
    STARS_INDEX = 1
    DATE_INDEX = 2

    def initialize(url, listing_id = nil)
      @listing_id = listing_id
      @property_name = ""
      @reviews_list = []
      super(url)
    end

    def scrap
      begin
        driver.get(url)
        dismiss_translation_modal
        property_name_flow
        reviews_button_flow
        modal_flow
        reviews_flow
      rescue => e
        puts "#{e}"
      ensure
        driver.quit
      end
    end

    private

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

    def property_name_flow
      @property_name = scrapping_wait.until do
        driver.find_element(css: PROPERTY_NAME_CONTAINER).text
      end
    end

    def reviews_button_flow
      reviews_button = scrapping_wait.until do
        driver.find_element(css: REVIEWS_BUTTON_CONTAINER)
      end
      reviews_button.click
    end

    def modal_flow
      modal = scrapping_wait.until do
        driver.find_element(css: REVIEWS_AREA_SCROLL_CONTAINER)
      end
      last_height = driver.execute_script('return arguments[0].scrollHeight', modal)
      loop do
        # Scroll to the bottom of the modal
        driver.execute_script('arguments[0].scrollTop = arguments[0].scrollHeight', modal)
        # Allow the request to be done and render the new reviews
        sleep 1
        new_height = driver.execute_script('return arguments[0].scrollHeight', modal)
        break if new_height == last_height

        last_height = new_height
      end
    end

    def reviews_flow
      reviews = scrapping_wait.until do
        driver.find_elements(css: SINGLE_REVIEW_CONTAINER)
      end

      reviews.each do |review|
        name, stars, month, year = parse_review_first_section(review)
        text = parse_review_second_section(review)
      end
    end

    def parse_review_first_section(review)
      name = scrapping_wait.until do
        review.find_element(css: NAME_CONTAINER).text
      end
      info_string = scrapping_wait.until do
        review.find_element(css: DATE_CONTAINER).text
      end

      [name] + extract_stars_and_date(info_string)
    end

    def parse_review_second_section(review)
      text = scrapping_wait.until do
        review.find_element(css: REVIEW_TEXT_CONTAINER).text
      end
    end

    def extract_stars_and_date(info_string)
      # The result of this operation will return [rating, # Stars, date, extra info]
      values = info_string.gsub("\n", "").gsub("·", "").split(',').map(&:strip)
      stars = values[STARS_INDEX].split(" ")[0]
      date = values[DATE_INDEX]

      [stars] + Formatting::Dates.month_and_year(date)
    end
  end
end
