class GithubAccount
  MAX_FETCH_REPOS = 100

  def initialize(user)
    @client = Octokit::Client.new(access_token: user.token)
  end

  def repositories
    @repositories ||= @client.repos({}, query: { type: 'owner', sort: 'asc', per_page: MAX_FETCH_REPOS })
  end
end
