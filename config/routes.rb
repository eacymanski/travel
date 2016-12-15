Rails.application.routes.draw do
  resources :destinations do
    member do
      get'default_image'
    end
  end
  resources :trips
  root 'trips#index'
end
