Rails.application.routes.draw do
  root 'users#index'

  # 改行するメリットとして、コードの差分がわかりやすくなるというのもある。
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }

  namespace :auth do
    # resource :user do ・・・という親子関係で、要認証な空間をわけてもいいかも。
    # 認証がもし不要になったときにルーティングを移動しないといけないと、ヘルパーメソッドなど影響が大きくなる可能性がある
    # メリットとして、ルーティングを見ただけで認証要不要がわかる、という考え方もある。
    resource :profile, only: %i[edit update]
    resources :works, only: %i[index edit update] do
      collection do
        post 'import'
      end
    end
  end

  resources :users, only: %i[index show]
end
