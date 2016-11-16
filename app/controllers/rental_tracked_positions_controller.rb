class RentalTrackedPositionsController < ApplicationController
  before_action :set_rental
  before_action :set_rental_tracked_position, only: [:edit, :update, :destroy]

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