class User < ApplicationRecord
  devise :database_authenticatable, :rememberable,
         :validatable, :omniauthable, omniauth_providers: %i[github]

  has_one :profile, dependent: :destroy

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      set_profile(user, auth)
    end
  end

  def self.set_profile(user, auth)
    profile = user.build_profile
    profile.name = auth.info.name
  end
  private_class_method :set_profile

end
