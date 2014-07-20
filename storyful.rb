#encoding: utf-8
require 'sinatra'
require 'twitter'
require 'json'
require 'yaml'

class Storyful < Sinatra::Application

  get '/' do
    config_file = YAML.load_file('./config/accounts.yml')
    accounts = config_file["accounts"]
    @accounts_with_tweets = accounts.map {|acc| {acc => request_tweets(acc)} }

    erb :index
  end

  get '/get_tweets' do

    @embeddable_tweets = request_tweets(params["user"])

    content_type :json
    @embeddable_tweets.to_json
  end

  private
  def request_tweets(user)
    get_new_client

    begin
      tweets = @client.user_timeline(user)
    rescue Twitter::Error::TooManyRequests => error
      get_new_client
      tweets = @client.user_timeline(user)
    end

    embeddable_tweets = []

    tweets.each do |tweet|
      begin
        embeddable_tweets << @client.oembed(tweet, :omit_script => true).html
      rescue Twitter::Error::TooManyRequests => error
        get_new_client
        embeddable_tweets << @client.oembed(tweet, :omit_script => true).html
      end
    end

    return embeddable_tweets
  end

  # Uses 'Storyful18July' API key firstly. If called again (in a rescue), it changes to Storyful18July2 API key
  def get_new_client
    # Use second API key if first is already set (i.e. it needs to be changed)
    if @client 
      # Storyful18July2
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = "4BlJArnM2Ris76EYxYZPTzbbo"
        config.consumer_secret     = "8sU8b2pTfrXKUnnb7gsISsw9XE8C7N6O9S7d1lkCRHYQgFxlpE"
        config.access_token        = "246377283-2JtsKsTmSFD2LPKeDRDcCT5kRZJnGSMMGyjsR8mm"
        config.access_token_secret = "cauN416DR8NMKHWN7xaEvY70yy1fkeZtRfTcxsn7U2Iqh"
      end

      p "Using Storyful18July2 API key"
    else
      # Storyful18July
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = "n5C6ZjrGRuMwmEfBnCqLYECgs"
        config.consumer_secret     = "iy2IUmqdBWhs9rXMVMFGJ6FipeEVnrtIbclWOKf7maBmHaMbFA"
        config.access_token        = "246377283-VfloCdp5VUh5vihWItWKBGzoDOMAunRyLBBCWWWS"
        config.access_token_secret = "wSAziYYh5expHYTlclP4TE3Jsautt1MVayxIUa4KOjXoj"
      end

      p "Using Storyful18July API key"
    end

  end

end