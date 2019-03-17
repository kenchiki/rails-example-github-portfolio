class Work < ApplicationRecord
  belongs_to :user

  mount_uploader :image, WorkImageUploader
  delegate :profile, to: :user
  delegate :name, to: :profile, prefix: true

  scope :published, -> { where(published: true) }

  def self.destroy_not_included_repos!(repositories)
    works = where.not(repository_id: repositories.map(&:id))
    works.destroy_all
    raise '作品を削除できませんでした。' unless works.all?(&:destroyed?)
  end

  def assign_attributes_by_repos(repository)
    # 初めてgithubリポジトリを取得する時のみリポジトリ名や説明文を反映する（あとでアプリ内で修正可能なため）
    assign_attributes(name: repository.name, description: repository.description) if new_record?
    assign_attributes(language: repository.language,
                      svn_url: repository.svn_url,
                      stargazers: repository.stargazers_count,
                      forks: repository.forks_count,
                      pushed_at: repository.pushed_at,
                      watchers: repository.watchers)
  end
end
