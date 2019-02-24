class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable

  before_create :has_one_default_build

  def has_one_default_build
    build_profile
  end
end
