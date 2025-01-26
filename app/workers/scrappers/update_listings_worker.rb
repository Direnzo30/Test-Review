module Scrappers
  class UpdateListingsWorker
    include Sidekiq::Worker

    def perform
      Listing.find_each do |listing|
        Scrappers::UpdateListingWorker.perform_async(listing.id)
      end
    end
  end
end
