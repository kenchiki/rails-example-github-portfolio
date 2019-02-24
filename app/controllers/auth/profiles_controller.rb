module Auth
  class ProfilesController < ApplicationController
    def edit
      @profile = current_user.profile
    end

    def update
      if current_user.profile.update(profile_params)
        redirect_to edit_auth_profile_path( @profile), notice: 'Profile was successfully updated.'
      else
        render :edit
      end
    end

    private

    def profile_params
      params.require(:profile).permit(:name, :pr)
    end
  end
end