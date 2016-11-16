class Rental < ApplicationRecord
  has_many :rental_tracked_positions, dependent: :restrict_with_error

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :total_distance, numericality: { greater_than_or_equal_to: 0.0 }

  before_validation :set_total_distance_before_validation

  protected

  def set_total_distance_before_validation
    self.total_distance ||= 0.0
  end
end
