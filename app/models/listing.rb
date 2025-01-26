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

  def words_for_cloud
    words = tags.last_30
    # words it's an array of [[word, count]]
    max_frequency = words.first[1].to_f
    words.map do |word, count|
      {
        text: word,
        # Scale for display purposes
        count: (count / max_frequency * 100).round(2)
      }
    end
  end
end
