class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :destroy]


  def index
    @profiles = Profile.all
  end


  def show
  end


  def new
    @profile = Profile.new
  end


  def edit
  end


  def create
    @profile = Profile.new(profile_params)

    respond_to do |format|
      if @profile.save
        redirect_to @profile, notice: 'Profile was successfully created.'
      else
        render :new
      end
    end
  end

  def update
    respond_to do |format|
      if @profile.update(profile_params)
         redirect_to @profile, notice: 'Profile was successfully updated.'
      else
        render :edit
      end
    end
  end


  def destroy
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to profiles_url, notice: 'Profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
  end


  def profile_params
    params.require(:profile).permit(:name, :pr)
  end
end
