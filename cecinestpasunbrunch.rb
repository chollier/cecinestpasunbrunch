require "sinatra"
require "instagram"

enable :sessions

CALLBACK_URL = "http://cecinestpasunbrunch.heroku.com/oauth/callback"

Instagram.configure do |config|
  config.client_id = "a731e18132984f5a830980bc3b21f9c7"
  config.client_secret = "cd9af3e8abcd4b828c6393b739efdca9"
end

get "/" do
  '<a href="/oauth/connect">Connect with Instagram</a>'
end

get "/oauth/connect" do
  redirect Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
end

get "/oauth/callback" do
  response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
  session[:access_token] = response.access_token
  redirect "/feed"
end

get "/feed" do
  client = Instagram.client(:access_token => session[:access_token])
  user = client.user

  html = "<h1>#{user.username}'s recent photos</h1>"
  for media_item in client.user_recent_media
    html << "<img src='#{media_item.images.thumbnail.url}'>"
  end
  html
end

get "/lyon69" do
  
  @images = Instagram.tag_recent_media("lyon69")
  
 # images
 
 html = "<h1>#Lyon69's recent photos</h1>"
 for media_item in Instagram.tag_recent_media("lyon69")
   html << "<img src='#{media_item.images.thumbnail.url}'>"
 end
 html

end