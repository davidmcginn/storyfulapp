require 'sinatra'
require 'twitter'
require 'json'

class Storyful < Sinatra::Application

  before '/*' do
  end

  after '/*' do
  end

  get '/' do

    # tweets = client.user_timeline("davemcginn_ie")

    # @embeddable_tweets = []

    # tweets.each do |tweet|
    #   @embeddable_tweets << client.oembed(tweet).html
    # end

    erb :index
  end

  get '/get_tweets' do

    @embeddable_tweets = get_tweets(params["user"])

# p @embeddable_tweets

    content_type :json
    @embeddable_tweets.to_json
  end

  private
  def get_tweets(user)
    # Storyful18July
    # client = Twitter::REST::Client.new do |config|
    #   config.consumer_key        = "n5C6ZjrGRuMwmEfBnCqLYECgs"
    #   config.consumer_secret     = "iy2IUmqdBWhs9rXMVMFGJ6FipeEVnrtIbclWOKf7maBmHaMbFA"
    #   config.access_token        = "246377283-VfloCdp5VUh5vihWItWKBGzoDOMAunRyLBBCWWWS"
    #   config.access_token_secret = "wSAziYYh5expHYTlclP4TE3Jsautt1MVayxIUa4KOjXoj"
    # end

    # Storyful18July2
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "4BlJArnM2Ris76EYxYZPTzbbo"
      config.consumer_secret     = "8sU8b2pTfrXKUnnb7gsISsw9XE8C7N6O9S7d1lkCRHYQgFxlpE"
      config.access_token        = "246377283-2JtsKsTmSFD2LPKeDRDcCT5kRZJnGSMMGyjsR8mm"
      config.access_token_secret = "cauN416DR8NMKHWN7xaEvY70yy1fkeZtRfTcxsn7U2Iqh"
    end


    tweets = client.user_timeline(user)

    embeddable_tweets = []

    tweets.each do |tweet|
      embeddable_tweets << client.oembed(tweet).html
    end

    return embeddable_tweets
  end

end