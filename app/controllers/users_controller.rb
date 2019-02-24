class UsersController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_user, only: %i[show]

  def index
    @users = User.order(id: :asc).limit(24)
    @works = Work.order(id: :asc).published.limit(24)
  end

  def show
  end

  def set_user
    @user = User.find(params[:id])
  end
end
