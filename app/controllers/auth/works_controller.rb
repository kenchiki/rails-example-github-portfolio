class Auth::WorksController < ApplicationController
  # %i表記で統一したほうがよさそう
  before_action :set_work, only: [:show, :edit, :update]

  def index
    # orderはmodel側で付けている。またorder付け忘れ防止gemもあったりする。
    @works = current_user.works
  end

  # 使ってないので削除したほうがよい。before_actionのしても消せる。
  def show
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

  # scaffoldでつくられるメソッドの後のほうが読みやすいかも
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
