class Listing < ApplicationRecord
  belongs_to :user
  has_many :reviews

  validates :name, :url, :user_id, presence: true
end
