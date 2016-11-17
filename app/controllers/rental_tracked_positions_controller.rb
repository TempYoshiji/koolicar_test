require 'rental_tracked_position_csv_importer' # Yes, I prefer to require instead of autoloading it

class RentalTrackedPositionsController < ApplicationController
  before_action :set_rental
  before_action :set_rental_tracked_position, only: [:edit, :update, :destroy]

  def import_csv
  end

  def do_import_csv
    # I know I could have used the same `import_csv` action and handle the GET and POST requests, but it feels messy
    importer = RentalTrackedPositionCsvImporter.new(@rental, params[:csv_file])
    importer.execute
    if importer.errors.present?
      flash[:danger] = importer.errors
    else
      flash[:success] = 'Successfully imported!'
    end
    redirect_to rental_rental_tracked_positions_path(@rental)
  end

  def index
    @rental_tracked_positions = @rental.rental_tracked_positions.ordered
  end

  def new
    @rental_tracked_position = @rental.rental_tracked_positions.new
  end

  def create
    @rental_tracked_position = @rental.rental_tracked_positions.new(rental_tracked_position_params)
    if @rental_tracked_position.save
      redirect_to rental_rental_tracked_positions_path(@rental), flash: { success: 'Success!' }
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @rental_tracked_position.update_attributes(rental_tracked_position_params)
      redirect_to rental_rental_tracked_positions_path(@rental), flash: { success: 'Success!' }
    else
      render 'edit'
    end
  end

  def destroy
    if @rental_tracked_position.destroy
      redirect_to rental_rental_tracked_positions_path(@rental), flash: { success: 'Success!' }
    else
      render 'edit'
    end
  end

  def destroy_all
    @rental.rental_tracked_positions.destroy_all
    redirect_to rental_rental_tracked_positions_path(@rental), flash: { success: 'Successfully deleted all positions related to this rental' }
  end

  protected

  def rental_tracked_position_params
    params.require(:rental_tracked_position).permit(:tracked_at, :latitude, :longitude)
  end

  def set_rental
    @rental = Rental.find(params[:rental_id])
  end

  def set_rental_tracked_position
    @rental_tracked_position = @rental.rental_tracked_positions.find(params[:id])
  end
end