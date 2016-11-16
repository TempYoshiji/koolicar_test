class RentalsController < ApplicationController
  def index
    @rentals = Rental.default_scoped
  end
end