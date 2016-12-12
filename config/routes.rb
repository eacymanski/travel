Rails.application.routes.draw do
  resources :destinations
  root 'destinations#index'
end
