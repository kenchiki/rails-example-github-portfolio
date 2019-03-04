Rails.application.routes.draw do
  root 'users#index'

  devise_for :users, skip: %i[registrations], controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :user do
    delete 'users' => 'devise/registrations#destroy', as: :user_registration
  end

  namespace :auth do
    resource :profile, only: %i[edit update]
    resources :works, only: %i[index edit update] do
      collection do
        post 'import'
      end
    end
  end

  resources :users, only: %i[index show]
end
