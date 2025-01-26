module Scrappers
  class UpdateListingWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'default'

    def perform(listing_id)
      listing = Listing.find(listing_id)
      Scrappers::Airbnb.new(url: listing.url, listing: listing).scrap
    end
  end
end
