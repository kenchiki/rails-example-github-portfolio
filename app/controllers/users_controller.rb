class UsersController < ApplicationController
  skip_before_action :authenticate_user!

  USERS_LIMIT = 24
  WORKS_LIMIT = 60

  def index
    @users = User.order(id: :desc).limit(USERS_LIMIT)
    @works = Work.includes(user: :profile).published.order(pushed_at: :desc).limit(WORKS_LIMIT)
  end

  def show
    @user = User.find(params[:id])
  end
end
