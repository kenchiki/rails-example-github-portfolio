class UsersController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_user, only: %i[show]

  def index
    # デフォルト昇順なので:ascは省略可
    # 24はマジックナンバー感がある。名前で理由が表せるとよい。
    @users = User.order(id: :asc).limit(24)
    # SQLはおそらく同じだと思うが、絞り込みは前段に行って、最後のorderをかけるという書き方もある
    @works = Work.order(id: :asc).published.limit(24)
  end

  def show
    # 一箇所(ここ)でしか呼んでいないので、ここに直接書いてもよいかも。before_actionなども削れる
  end

  private

  # privateで十分
  def set_user
    @user = User.find(params[:id])
  end
end
