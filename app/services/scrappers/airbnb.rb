module Scrappers
  class Airbnb < Scrappers::AirbnbLight
    attr_accessor :reviews_list, :tags_list

    REVIEWS_BUTTON_CONTAINER = 'button[data-testid="pdp-show-all-reviews-button"]'.freeze
    REVIEWS_AREA_SCROLL_CONTAINER = 'div[role="dialog"] ._17itzz4'.freeze
    SINGLE_REVIEW_CONTAINER = '[data-review-id]'.freeze
    NAME_CONTAINER = 'div:first-child h2'.freeze
    DATE_CONTAINER = 'div.s78n3tv.atm_c8_1w0928g.atm_g3_1dd5bz5.atm_cs_10d11i2.atm_9s_1txwivl.atm_h_1h6ojuz.dir.dir-ltr'.freeze
    REVIEW_TEXT_CONTAINER = 'span.l1h825yc.atm_kd_19r6f69_24z95b.atm_kd_19r6f69_1xbvphn_1oszvuo.dir.dir-ltr'.freeze
    STARS_INDEX = 1
    DATE_INDEX = 2

    def initialize(url:, listing: nil, user_id: nil, apply_save: true)
      super(url: url, user_id: user_id)
      @listing = listing
      @reviews_list = []
      @tags_list = []
      @apply_save = apply_save
    end

    def scrap
      begin
        driver.get(url)
        # steps coming from AirbnbLight
        dismiss_translation_modal
        property_name_flow
        # en of shared steps
        reviews_button_flow
        modal_flow
        reviews_flow
        tags_flow
        store_info if @apply_save

        return @listing
      rescue => e
        puts "#{e}"
        return nil
      ensure
        driver.quit
      end
    end

    private

    # Step 3
    def reviews_button_flow
      reviews_button = scrapping_wait.until do
        driver.find_element(css: REVIEWS_BUTTON_CONTAINER)
      end
      reviews_button.click
    end

    # Step 4
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

    # Step 5
    def reviews_flow
      reviews = scrapping_wait.until do
        driver.find_elements(css: SINGLE_REVIEW_CONTAINER)
      end

      reviews.each do |review|
        user, stars, month, year = parse_user_stars_and_dates(review)
        text = parse_review_comment(review)

        @reviews_list << {
          user: user,
          month: month,
          year: year.to_i,
          stars: stars.to_i,
          comment: text.gsub("\n", " "),
          listing_id: @listing&.id,
          source_id: review.attribute(SINGLE_REVIEW_CONTAINER[1...-1]) # Remove the brackets for accessing the attribute
        }
      end
    end

    def parse_user_stars_and_dates(review)
      user = scrapping_wait.until do
        review.find_element(css: NAME_CONTAINER).text
      end
      info_string = scrapping_wait.until do
        review.find_element(css: DATE_CONTAINER).text
      end

      [user] + extract_stars_and_date(info_string)
    end

    def parse_review_comment(review)
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

    # Step 6
    def tags_flow
      frequencies = Reporting::WordCloud.new(reviews: @reviews_list).generate
      frequencies.each do |word, count|

        @tags_list << {
          word: word,
          count: count,
          listing_id: @listing&.id
        }
      end
    end

    # Step 7
    def store_info
      ActiveRecord::Base.transaction do
        # First time running the process
        if @listing.nil?
          @listing = Listing.new.tap do |listing|
            listing.user_id = @user_id
            listing.name = @property_name
            listing.url = @url
            listing.full_scrapped = true
          end
          @listing.save!
          @reviews_list.each { |r| r[:listing_id] = @listing.id }
          @tags_list.each { |t| t[:listing_id] = @listing.id }
        else
          # This ensures updating the record for the snapshot to see when the porcess was triggered
          @listing.update!(name: @property_name, full_scrapped: true, updated_at: Time.now.utc)
        end

        # Avoid creating unnecessary reviews 
        Review.upsert_all(@reviews_list, unique_by: [:listing_id, :source_id])
        Tag.upsert_all(@tags_list, unique_by: [:listing_id, :word])
      end
    end
  end
end
