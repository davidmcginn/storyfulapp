require 'sinatra'
require 'twitter'

class Storyful < Sinatra::Application

  get '/' do

    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "n5C6ZjrGRuMwmEfBnCqLYECgs"
      config.consumer_secret     = "iy2IUmqdBWhs9rXMVMFGJ6FipeEVnrtIbclWOKf7maBmHaMbFA"
      config.access_token        = "246377283-VfloCdp5VUh5vihWItWKBGzoDOMAunRyLBBCWWWS"
      config.access_token_secret = "wSAziYYh5expHYTlclP4TE3Jsautt1MVayxIUa4KOjXoj"
    end

    tweets = client.user_timeline("davemcginn_ie")

    @embeddable_tweets = []

    # p client.oembed(tweets.first).html

    tweets.each do |tweet|
      @embeddable_tweets << client.oembed(tweet).html
    end

    erb :index
  end
  
end