class Work < ApplicationRecord
  belongs_to :user

  mount_uploader :image, WorkImageUploader
  delegate :profile, to: :user
  delegate :name, to: :profile, prefix: true

  scope :published, -> { where(published: true) }

  def self.destroy_not_included_repos!(repositories)
    works = where.not(repository_id: repositories.map(&:id))
    # delete_allだとSQLが1つですむので、そちらでもよいかもしれない
    works.destroy_all
    raise '作品を削除できませんでした。' unless works.all?(&:destroyed?)
  end

  def update_or_create_by_repository(repository)
    # nameとdescriptionがnew_recordのときのみ処理する意図がコードから読み取りにくいため、コメントがあるとよい
    assign_attributes(name: repository.name, description: repository.description) if new_record?
    assign_attributes(language: repository.language,
                      svn_url: repository.svn_url,
                      stargazers: repository.stargazers_count,
                      forks: repository.forks_count,
                      pushed_at: repository.pushed_at,
                      watchers: repository.watchers)
    save!
  end
end
