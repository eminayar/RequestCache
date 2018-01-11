require 'rubygems'
gem 'google-api-client', '>0.7'
require 'google/apis'
require 'google/apis/youtube_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

require 'fileutils'
require 'json'
require 'csv'
require 'time'

# REPLACE WITH VALID REDIRECT_URI FOR YOUR CLIENT
REDIRECT_URI = 'http://localhost'
APPLICATION_NAME = 'YouTube Data API Ruby Tests'

# REPLACE WITH NAME/LOCATION OF YOUR client_secrets.json FILE
CLIENT_SECRETS_PATH = File.expand_path "client_secret.json"

# REPLACE FINAL ARGUMENT WITH FILE WHERE CREDENTIALS WILL BE STORED
CREDENTIALS_PATH = File.join( Dir.pwd  , "credentials" ,
                              "youtube-quickstart-ruby-credentials.yaml")

# SCOPE FOR WHICH THIS SCRIPT REQUESTS AUTHORIZATION
SCOPE = Google::Apis::YoutubeV3::AUTH_YOUTUBE_FORCE_SSL

def authorize
  FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

  client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
  token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
  authorizer = Google::Auth::UserAuthorizer.new(
      client_id, SCOPE, token_store)
  user_id = 'default'
  credentials = authorizer.get_credentials(user_id)
  if credentials.nil?
    url = authorizer.get_authorization_url(base_url: REDIRECT_URI)
    puts "Open the following URL in the browser and enter the " +
             "resulting code after authorization"
    puts url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: REDIRECT_URI)
  end
  credentials
end

# Initialize the API
service = Google::Apis::YoutubeV3::YouTubeService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorize

CSV.open("data.csv","wb") do |csv|
  csv << ["title","youtubeId","commentCount","dislikeCount","likeCount","viewCount","channelId","channelTitle","timestamp"]
end
counter =1 
File.open("video_id_list.txt","r").each do |f|
  response = service.list_videos( 'snippet,contentDetails,statistics' , id: f )
  f.chomp!
  snippet=JSON.parse( response.to_json ).fetch("items")[0].fetch("snippet")
  statistics=JSON.parse( response.to_json ).fetch("items")[0].fetch("statistics")
  commentCount=statistics.fetch("commentCount")
  dislikeCount=statistics.fetch("dislikeCount")
  likeCount=statistics.fetch("likeCount")
  viewCount=statistics.fetch("viewCount")
  title=snippet.fetch("title")
  channelId=snippet.fetch("channelId")
  channelTitle=snippet.fetch("channelTitle")
  publishedAt=snippet.fetch("publishedAt").partition("T")
  year=publishedAt[0].partition("-")[0]
  month=publishedAt[0].partition("-")[2].partition("-")[0]
  day=publishedAt[0].partition("-")[2].partition("-")[2]
  hour=publishedAt[2].partition(".")[0].partition(":")[0]
  minute=publishedAt[2].partition(".")[0].partition(":")[2].partition(":")[0]
  second=publishedAt[2].partition(".")[0].partition(":")[2].partition(":")[2]
  timestamp=Time.new( year , month , day , hour , minute , second , "+00:00").to_i
  CSV.open("data.csv","a+") do |csv|
    csv <<[title,f,commentCount,dislikeCount,likeCount,viewCount,channelId,channelTitle,timestamp]
  end
  puts counter
  counter +=1
end
