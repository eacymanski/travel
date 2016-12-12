Rails.application.routes.draw do
  resources :destinations, only: [:show, :edit, :update, :new, :create]
  resources :trips
  root 'trips#index'
end
