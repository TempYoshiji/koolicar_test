class RentalTrackedPosition < ApplicationRecord
  belongs_to :rental

  validates :rental, presence: true
  validates :tracked_at, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :tracked_at, uniqueness: { scope: [:rental_id] } # can't have two records for the same rental_id and tracked_at

  scope :ordered, -> { order(tracked_at: :desc) }
end
