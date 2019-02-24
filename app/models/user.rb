class User < ApplicationRecord
  devise :database_authenticatable, :rememberable,
         :validatable, :omniauthable, omniauth_providers: %i[github]

  has_one :profile, dependent: :destroy
  has_one :omni_auth_token, dependent: :destroy
  has_many :works, -> { order(id: :asc) }, dependent: :destroy

  delegate :token, to: :omni_auth_token
  delegate :repositories, to: :github_account
  delegate :name, :pr, :pr?, :avatar, :avatar?, to: :profile

  def published_works
    works.published
  end

  def import_works_from_github
    Work.transaction do
      works.destroy_not_included_repos!(repositories)
      repositories.each do |repository|
        work = works.find_or_initialize_by(repository_id: repository.id)
        work.update_or_create_by_repository(repository)
      end
    end
  end


  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      build_profile_by_auth(user, auth)
    end
    update_or_create_token(user, auth)
    user
  end

  def self.build_profile_by_auth(user, auth)
    profile = user.build_profile
    profile.name = auth.info.name
    profile.pr = auth.extra.raw_info.bio
    profile.remote_avatar_url = auth.info.image
  end

  def self.update_or_create_token(user, auth)
    user.omni_auth_token&.destroy!
    user.create_omni_auth_token(token: auth.dig(:credentials, :token))
  end

  private_class_method :build_profile_by_auth, :update_or_create_token

  private

  def github_account
    @github_account ||= GithubAccount.new(self)
  end
end
