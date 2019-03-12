class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable,
         :validatable, :omniauthable, omniauth_providers: %i[github]

  has_one :profile, dependent: :destroy
  has_many :works, dependent: :destroy
  has_many :published_works, -> { merge(Work.published) }, class_name: 'Work'

  # このクラスの中からしか呼ばないメソッドであれば、delegateせずに直接呼んでも良さそう
  delegate :repositories, to: :github_account
  delegate :name, :pr, :pr?, :avatar, :avatar?, to: :profile

  # save!してるのでメソッド名に!があってもよいかも
  def self.find_or_create_user(auth)
    # find_or_initialize_byでも書ける
    user = find_by(provider: auth.provider, uid: auth.uid) || build_user_by_auth(auth)
    user.assign_attributes(access_token: auth.dig(:credentials, :token))
    user.save!
    user
  end

  def self.build_user_by_auth(auth)
    # tapはなくてもよさそう
    User.new.tap do |user|
      user.email = auth.info.email
      # パスワードは使っていないので、可能ならカラムごと削除しておけたほうが明示的
      user.password = Devise.friendly_token[0, 20]
      user.provider = auth.provider
      user.uid = auth.uid
      # 16行目で実装済みなのでここでは不要と思われる
      user.access_token = auth.dig(:credentials, :token)
      build_profile_by_auth(user, auth)
    end
  end

  # これはインスタンスメソッドでもよさそう
  # プロファイルを作る処理(ファクトリメソッド的な処理)なので、Profileクラス側に寄せてもよい
  # ユーザーとProfileとは、現状ライフサイクルが同じなので、プロファイルとして切り出さずにユーザーの値にしてもよい
  def self.build_profile_by_auth(user, auth)
    profile = user.build_profile
    profile.name = auth.info.name
    profile.pr = auth.extra.raw_info.bio
    profile.remote_avatar_url = auth.info.image
  end

  private_class_method :build_user_by_auth, :build_profile_by_auth

  def import_works_from_github
    Work.transaction do
      works.destroy_not_included_repos!(repositories)
      repositories.each do |repository|
        work = works.find_or_initialize_by(repository_id: repository.id)
        work.update_or_create_by_repository(repository)
        # initializeしているここでsave!を呼んでもわかりやすそう
        # その際はここではset_attributes(？)ぐらいにとどめる
      end
    end
  end

  private

  def github_account
    @github_account ||= GithubAccount.new(self)
  end
end
