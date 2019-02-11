class DashboardDataService
  def initialize(screen_name)
    @screen_name = screen_name
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = Rails.application.credentials.twitter_app[:api_key]
      config.consumer_secret = Rails.application.credentials.twitter_app[:api_secret]
      config.access_token = Rails.application.credentials.twitter_app[:access_token]
      config.access_token_secret = Rails.application.credentials.twitter_app[:access_token_secret]
    end
  end

  def tweets
    @client.user_timeline(@screen_name)
  end
end