Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "application#index"
  get '/dashboard', to: 'application#dashboard'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
end
