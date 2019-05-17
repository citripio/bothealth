Rails.application.routes.draw do
  resources :organizations
  resources :facebook_pages
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "application#index"
  get '/dashboard', to: 'application#dashboard'
  get '/invitation/:invitation_hash', to: 'application#invitation'
  devise_for :users, controllers: { 
  	omniauth_callbacks: 'users/omniauth_callbacks', 
  	registrations: 'users/registrations'
  }
end
