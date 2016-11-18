class RentalTrackedPosition < ApplicationRecord
  attr_accessor :skip_compute_total_distance

  belongs_to :rental

  scope :ordered, -> { order(tracked_at: :desc) }

  validates :rental, presence: true
  validates :tracked_at, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :tracked_at, uniqueness: { scope: [:rental_id, :latitude, :longitude] } # avoid duplicates
  # FYI: your CSV file contains several records for the same timestamp

  after_save :compute_total_distance
  after_destroy :compute_total_distance

  protected

  def compute_total_distance
    return if @skip_compute_total_distance
    self.rental.set_computed_total_distance
    self.rental.save
  end
end
