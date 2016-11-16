Rails.application.routes.draw do
  resources :rentals, except: :show do
    resources :rental_tracked_positions, except: :show do
      collection do
        get :import_csv
        post :do_import_csv
        delete :destroy_all
      end
    end
  end
end
