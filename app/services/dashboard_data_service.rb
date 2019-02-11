class DashboardDataService
  def initialize(user)
    @user = user
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = Rails.application.credentials.twitter_app[:api_key]
      config.consumer_secret = Rails.application.credentials.twitter_app[:api_secret]
      config.access_token = user.twitter_access_token
      config.access_token_secret = user.twitter_access_secret
    end
  end

  def tweets
    @client.user_timeline
  end
end