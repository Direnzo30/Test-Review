class Review < ApplicationRecord
  belongs_to :listing

  validates :source_id, :listing_id, :user, :month, :year, :stars, :comment, presence: true

  scope :by_month_from_year, ->(year) { where(year: year).group(:month).pluck("reviews.month, count(reviews.month)") }
end
