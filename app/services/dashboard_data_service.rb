class DashboardDataService
  attr_reader :client
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
    @tweets ||= @client.user_timeline(count: 500)
  end

  def mentions
    @mentions ||= @client.mentions_timeline
  end

  def followers
    @client.followers
  end

  def friends
    @client.friends
  end

  def profile
    @profile ||= begin
      profile = @client.user
      {
        avatar: profile.profile_image_uri.to_str.gsub('_normal', ''),
        name: profile.name,
        screen_name: profile.screen_name,
        tweets_count: profile.tweets_count,
        friends_count: profile.friends_count,
        followers_count: profile.followers_count,
        favorites_count: original_tweets.map(&:favorite_count).sum,
        retweets_count: original_tweets.map(&:retweet_count).sum,
        hit_tweet: hit_tweet
      }
    end
  end

  # private

  def original_tweets
    @original_tweets ||= tweets.filter { |t| !t.retweeted_tweet? }
  end

  def hit_tweet
    original_tweets.max { |t| t.favorite_count + t.retweet_count }
  end
end