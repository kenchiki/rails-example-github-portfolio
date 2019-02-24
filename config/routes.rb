Rails.application.routes.draw do
  root 'home#index'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  namespace :auth do
    resource :profile, only: %i[edit update]
  end
  resource :home, only: %i[index]
end
