class RentalTrackedPosition < ApplicationRecord
  attr_accessor :skip_compute_total_distance
  # non-persisted attribute to be able to skip the compute_total_distance call when creating/updating/deleting several
  # RentalTrackedPosition records at once and only call it once when all the records are created/updated/deleted

  belongs_to :rental

  scope :ordered, -> { order(tracked_at: :desc) }

  validates :rental, presence: true
  validates :tracked_at, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :tracked_at, uniqueness: { scope: [:rental_id, :latitude, :longitude] } # avoid duplicates
  # FYI: your CSV file contains several records for the same timestamp, some are total duplicates,
  # others have different lat/long for the same timestamp

  after_save :compute_total_distance_after_save_or_destroy
  after_destroy :compute_total_distance_after_save_or_destroy

  protected

  def compute_total_distance_after_save_or_destroy
    return if @skip_compute_total_distance
    self.rental.set_computed_total_distance
    self.rental.save
  end
end
