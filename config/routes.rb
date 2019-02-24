Rails.application.routes.draw do
  root 'users#index'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  namespace :auth do
    resource :profile, only: %i[edit update]
    resources :works, only: %i[index show edit update] do
      collection do
        post 'import'
      end
    end
  end

  resources :users, only: %i[index show]
end
