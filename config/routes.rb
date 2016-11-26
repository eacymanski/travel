Rails.application.routes.draw do
  resources :destinations
  resources :trips
  root 'trips#index'
end
