class Listing < ApplicationRecord
  belongs_to :user
  has_many :reviews
  has_many :tags

  validates :name, :url, :user_id, presence: true

  def reviews_by_month_for_year(year)
    data = reviews.by_month_from_year(year)
    results = {}
    # Initialize the months counter for getting complete data for the chart
    Date::MONTHNAMES.compact.each do |month|
      results[month] = 0
    end
    data.each do |month, reviews|
      results[month] = reviews
    end

    results
  end

  def reviews_years
    reviews.pluck("DISTINCT(year)").sort
  end
end
