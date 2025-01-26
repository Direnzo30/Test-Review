class Tag < ApplicationRecord
  belongs_to :listing

  validates :word, :count, presence: true

  scope :last_30, ->() { order(count: :desc).limit(30).pluck("tags.word, tags.count") }
end
