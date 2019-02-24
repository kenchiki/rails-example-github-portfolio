module Auth
  class WorksController < ApplicationController
    before_action :set_work, only: [:show, :edit, :update]

    def index
      @works = current_user.works
    end

    def show
    end

    def edit
    end

    def import
      current_user.import_works_from_github
      redirect_to auth_works_path, notice: 'GitHubのリポジトリを読み込みました。'
    end

    def update
      if @work.update(work_params)
        redirect_to [:auth, @work], notice: '作品を更新しました。'
      else
        render :edit
      end
    end

    private

    def set_work
      @work = current_user.works.find(params[:id])
    end

    def work_params
      params.require(:work).permit(:name, :description)
    end
  end
end
