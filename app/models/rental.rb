class Rental < ApplicationRecord
  has_many :rental_tracked_positions, dependent: :restrict_with_error

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :total_distance, numericality: { greater_than_or_equal_to: 0.0 }

  before_validation :set_total_distance_before_validation

  def erase_all_tracked_positions
    transaction do
      self.rental_tracked_positions.each do |rtp|
        rtp.skip_compute_total_distance = true
        rtp.destroy
      end
      self.set_computed_total_distance
      self.save
    end
  end

  def set_computed_total_distance
    self.total_distance = compute_total_distance
  end

  def compute_total_distance
    total_distance_in_km = 0.0
    positions = self.rental_tracked_positions.order(tracked_at: :asc)
    positions.each_with_index do |position, i|
      next_position = positions[i+1]
      if next_position
        current_pos_arr = [position.latitude, position.longitude]
        next_pos_arr = [next_position.latitude, next_position.longitude]
        total_distance_in_km += Geocoder::Calculations.distance_between(current_pos_arr, next_pos_arr, units: :km)
      end
    end
    total_distance_in_km
  end

  protected

  def set_total_distance_before_validation
    self.total_distance ||= 0.0
  end
end
