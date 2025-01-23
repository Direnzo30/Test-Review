class Review < ApplicationRecord
  belongs_to :listing

  validates :source_id, :listing_id, :user, :month, :year, :stars, :content, presence: true
end
