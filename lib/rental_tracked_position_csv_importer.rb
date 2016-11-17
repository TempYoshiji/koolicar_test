# This class should probably be located at lib/importers/rental_tracked_position_importer.rb
# This folder lib/importers/* would contain Importer classes
# But for the purpose of this exercise, I did not took the time to create this folder
require 'csv'

class RentalTrackedPositionCsvImporter
  attr_accessor :rental, :csv_uploaded_file, :csv_parsed, :errors

  def initialize(rental, csv_uploaded_file)
    @rental = rental
    @csv_uploaded_file = csv_uploaded_file
    @errors = []
  end

  def validate_can_import
    @errors.push('object given is not a Rental persisted object!') unless @rental.kind_of?(Rental) && @rental.persisted?
    begin
      @csv_parsed = CSV.read(@csv_uploaded_file.path, col_sep: ';') # usually the col_sep is a coma , but your CSV files used ; instead
    rescue => error
      # could log the error *eventually*
      @errors.push('CSV file is blank or not valid!')
      @errors.push(error) unless Rails.env.production? # we don't want to show too much in production mode!
    end
  end

  def import_csv_content
    ActiveRecord::Base.transaction do # create everything or do nothing!
      @csv_parsed.each do |row|
        # row[0] -> tracked_at
        # row[1] -> latitude
        # row[2] -> longitude
        next if row[0].blank? || row[1].blank? || row[2].blank? # skipping lines with empty value(s)
        begin
          attrs = { latitude: Float(row[1]), longitude: Float(row[2]) } # casting as Float like this will raise an error, whereas "wtf".to_f => 0.0
          attrs[:tracked_at] = Time.at(Integer(row[0])).to_datetime
          attrs[:skip_compute_total_distance] = true # hook to avoid the useless n-1 calls where n = number of positions to create
          @rental.rental_tracked_positions.new(attrs)
        rescue => error
          raise error unless Rails.env.production? # should log the error if in production mode
        end
      end
      unless @rental.save # triggers the creation of all the new RentalTrackedPosition records
        @errors.push('Some data was not valid')
      end
    end
  end

  def execute
    validate_can_import
    if @errors.present?
      return false
    else
      import_csv_content
      @rental.reload # reloading to get rid off the invalid RentalTrackedPosition records
      @rental.set_computed_total_distance # call to compute the total_distance with all the persisted RentalTrackedPosition records
      @rental.save
    end
    @errors.blank?
  end
end