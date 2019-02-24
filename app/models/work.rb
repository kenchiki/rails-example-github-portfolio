class Work < ApplicationRecord
  belongs_to :user

  def self.destroy_not_included_repos!(repositories)
    works = where.not(repository_id: repositories.map(&:id))
    works.destroy_all
    raise '作品を削除できませんでした。' unless works.all?(&:destroyed?)
  end

  def update_or_create_by_repository(repository)
    assign_attributes(name: repository.name, description: repository.description) if new_record?
    assign_attributes(language: repository.language,
                      svn_url: repository.svn_url,
                      stargazers: repository.stargazers_count,
                      forks: repository.forks_count,
                      watchers: repository.watchers)
    save!
  end
end
