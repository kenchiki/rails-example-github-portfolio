Rails.application.routes.draw do
  root 'home#index'
  devise_for :users
  namespace :admin do
    resources :users, only: [] do
      resource :profile
    end
  end
  resource :home, only: %i(index)
end
