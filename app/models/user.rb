class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable,
         :validatable, :omniauthable, omniauth_providers: %i[github]

  has_one :profile, dependent: :destroy
  has_many :works, dependent: :destroy
  has_many :published_works, -> { published }, class_name: 'Work'

  delegate :name, :pr, :pr?, :avatar, :avatar?, to: :profile

  def self.find_or_create_user!(auth)
    user = find_by(provider: auth.provider, uid: auth.uid) || build_user_by_auth(auth)
    user.assign_attributes(access_token: auth.dig(:credentials, :token))
    user.save!
    user
  end

  def self.build_user_by_auth(auth)
    User.new do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.provider = auth.provider
      user.uid = auth.uid
      user.build_profile_by_auth(auth)
    end
  end

  private_class_method :build_user_by_auth

  def import_works_from_github
    Work.transaction do
      works.destroy_not_included_repos!(github_account.repositories)
      github_account.repositories.each do |repository|
        work = works.find_or_initialize_by(repository_id: repository.id)
        work.assign_attributes_by_repos(repository)
        work.save!
      end
    end
  end

  def build_profile_by_auth(auth)
    profile = build_profile
    profile.name = auth.info.name
    profile.pr = auth.extra.raw_info.bio
    profile.remote_avatar_url = auth.info.image
  end

  private

  def github_account
    @github_account ||= GithubAccount.new(self)
  end
end
