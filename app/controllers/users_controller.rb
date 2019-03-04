class UsersController < ApplicationController
  skip_before_action :authenticate_user!

  USERS_LIMIT = 24
  WORKS_LIMIT = 24

  def index
    @users = User.order(id: :desc).limit(USERS_LIMIT)
    @works = Work.published.order(id: :desc).limit(WORKS_LIMIT)
  end

  def show
    @user = User.find(params[:id])
  end
end
