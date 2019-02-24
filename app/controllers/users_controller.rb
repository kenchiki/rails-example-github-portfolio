class UsersController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_user, only: %i[show]

  def index
  end

  def show
  end

  def set_user
    @user = User.find(params[:id])
  end
end
