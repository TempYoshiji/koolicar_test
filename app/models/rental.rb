class Rental < ApplicationRecord
  validates :name, uniqueness: true
  validates :total_distance, numericality: { greater_than_or_equal_to: 0.0 }
end
