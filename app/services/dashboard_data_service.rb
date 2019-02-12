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
    @tweets ||= @client.user_timeline(count: 200)
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
        followers_count: profile.followers_count
      }
    end
  end

  def hit_tweet
    original_tweets.max { |t1, t2| (t1.favorite_count + t1.retweet_count) <=> (t2.favorite_count + t2.retweet_count) }
  end

  def favorites_count
    original_tweets.map(&:favorite_count).sum
  end

  def retweets_count
    original_tweets.map(&:retweet_count).sum
  end

  def impact_trend
    tweets_count = original_tweets_by_week.each_with_index.map { |tweets, i| [i - 3, tweets.length] }
    retweets_count = original_tweets_by_week.each_with_index.map { |tweets, i| [i -3, tweets.map(&:retweet_count).sum] }
    favorites_count = original_tweets_by_week.each_with_index.map { |tweets, i| [i - 3, tweets.map(&:favorite_count).sum] }
    [
        { name: 'Tweets', data: tweets_count },
        { name: 'Favorites', data: favorites_count },
        { name: 'Retweets', data: retweets_count }
    ]
  end

  private

  def original_tweets
    @original_tweets ||= tweets.filter { |t| !t.retweeted_tweet? }
  end

  def original_tweets_by_week
    @original_tweets_by_week ||= begin
      tweets = []
      4.times do |n|
        tweets << original_tweets.filter { |tweet| ((n + 1).weeks.ago..n.weeks.ago).include? tweet.created_at }
      end
      tweets.reverse
    end
  end
end