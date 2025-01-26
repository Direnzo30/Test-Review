class Tag < ApplicationRecord
  belongs_to :listing

  validates :word, :count, presence: true
end
