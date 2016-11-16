Rails.application.routes.draw do
  resources :rentals, except: :show do
    resources :rental_tracked_positions, except: :show
  end
end
