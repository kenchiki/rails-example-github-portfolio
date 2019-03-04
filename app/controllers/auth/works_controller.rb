class Auth::WorksController < ApplicationController
  before_action :set_work, only: %i[edit update]

  def index
    @works = current_user.works.order(id: :desc)
  end

  def edit
  end

  def update
    if @work.update(work_params)
      redirect_to edit_auth_work_path(@work), notice: '作品を更新しました。'
    else
      render :edit
    end
  end

  def import
    current_user.import_works_from_github
    redirect_to auth_works_path, notice: 'GitHubのリポジトリを読み込みました。'
  end

  private

  def set_work
    @work = current_user.works.find(params[:id])
  end

  def work_params
    params.require(:work).permit(:name, :description, :image, :remove_image, :image_cache, :published)
  end
end
