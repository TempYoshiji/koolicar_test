class RentalsController < ApplicationController
  before_action :set_rental, only: [:edit, :update, :destroy]

  def index
    @rentals = Rental.default_scoped
  end

  def new
    @rental = Rental.new
  end

  def create
    @rental = Rental.new(rental_params)
    if @rental.save
      redirect_to rentals_path, flash: { success: 'Success!' }
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @rental.update_attributes(rental_params)
      redirect_to rentals_path, flash: { success: 'Success!' }
    else
      render 'edit'
    end
  end

  def destroy
    if @rental.destroy
      redirect_to rentals_path, flash: { success: 'Success!' }
    else
      render 'edit'
    end
  end

  protected

  def rental_params
    params.require(:rental).permit(:name)
  end

  def set_rental
    @rental = Rental.find(params[:id])
  end
end