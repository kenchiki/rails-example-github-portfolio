class Users::RegistrationsController < Devise::RegistrationsController
  # もしDeviseのルーティングの定義の設定で、不要なアクションへのルーティングを無効化できれば意図が明確になるかも
  # 参考その1→https://qiita.com/chamao/items/de00920c343a3e237d20
  # 参考その2↓
  # as :user do
  #  delete 'logout' => 'devise/sessions#destroy', as: :destroy_user_session
  # end
  before_action :not_found, except: %i[destroy]

  private

  def not_found
    head :not_found
  end
end
