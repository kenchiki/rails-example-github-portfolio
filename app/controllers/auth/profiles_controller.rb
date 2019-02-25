class Auth::ProfilesController < ApplicationController
  def edit
    @profile = current_user.profile
  end

  def update
    if current_user.profile.update(profile_params)
      redirect_to edit_auth_profile_path(@profile), notice: 'Profile was successfully updated.'
    else
      render :edit
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:name, :pr, :avatar, :remove_avatar, :avatar_cache)
  end
end
