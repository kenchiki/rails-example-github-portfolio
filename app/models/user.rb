class User < ApplicationRecord
  devise :database_authenticatable, :rememberable,
         :validatable, :omniauthable, omniauth_providers: %i[github]

  has_one :profile, dependent: :destroy
  has_one :omni_auth_token, dependent: :destroy

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      build_profile_by_auth(user, auth)
    end
    update_or_create_auth_token(user, auth)
    user
  end

  def self.build_profile_by_auth(user, auth)
    profile = user.build_profile
    profile.name = auth.info.name
  end

  def self.update_or_create_auth_token(user, auth)
    user.omni_auth_token&.destroy!
    user.create_omni_auth_token(token: auth.dig(:credentials, :token))
  end

  private_class_method :build_profile_by_auth, :update_or_create_auth_token
end
