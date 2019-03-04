class Auth::ProfilesController < ApplicationController
  before_action :set_profile, only: %i[edit update]

  def edit
  end

  def update
    if @profile.update(profile_params)
      redirect_to edit_auth_profile_path, notice: 'プロフィールを更新しました。'
    else
      render :edit
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:name, :pr, :avatar, :remove_avatar, :avatar_cache)
  end

  def set_profile
    @profile = current_user.profile
  end
end
