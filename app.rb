require 'net/http'
require 'uri'
require 'sinatra/base'
require 'webrick'
require 'webrick/https'
require 'openssl'
require 'json'
require 'oauth'

class CheckinServer  < Sinatra::Base
    clientid = "" #foursquare app client id
    clientsecret = "" #foursquare app client secret
    redirecturi = "" #foursquare app redirect_uri
    fsqaccesstoken = "" #foursquare app user access_token from /login

    consumerkey = "" #twitter app consumer key
    consumersecret = "" #twitter app consumer secret
    oauth_token = "" #twitter app user oauth_token
    oauth_token_secret = "" #twitter app user oauth_token_secret
    
    CERT_PATH = "" #path to folder containing server.key & server.crt
    DOCUMENT_ROOT = "" #path to folder containing this file

    get '/' do
        "Foursquare checkins update your twitter location in realtime."
    end
    get '/login' do
      code = params[:code]
      if code
        url = "https://foursquare.com/oauth2/access_token?client_id=" + clientid + "&client_secret=" + clientsecret + "&grant_type=authorization_code&redirect_uri=" + redirecturi + "&code=" + code
	tokenhash = JSON.parse(RestClient.get url)
        @token = tokenhash["access_token"]
      else
        redirect "https://foursquare.com/oauth2/authenticate?client_id=" + clientid + "&response_type=code&redirect_uri=" + redirecturi
      end
    end
    post '/checkin' do
      checkinhash = JSON.parse(params[:checkin])
      location = checkinhash["venue"]["name"]
      consumer = OAuth::Consumer.new(consumerkey, consumersecret, {:site => "https://api.twitter.com", :request_token_path => '/oauth/request_token', :access_token_path => '/oauth/access_token', :authorize_path => '/oauth/authorize', :scheme => :header})
      token_hash = { :oauth_token => oauth_token, :oauth_token_secret => oauth_token_secret }
      access_token = OAuth::AccessToken.from_hash(consumer, token_hash ) 
      access_token.post('https://api.twitter.com/1.1/account/update_profile.json', {'location' => location} , { 'Accept' => 'application/xml' })
    end
end 
 
webrick_options = {
        :Port               => 7896,
        :DocumentRoot       => DOCUMENT_ROOT,
        :SSLEnable          => true,
        :SSLVerifyClient    => OpenSSL::SSL::VERIFY_NONE,
        :SSLCertificate     => OpenSSL::X509::Certificate.new(  File.open(File.join(CERT_PATH, "server.crt")).read),
        :SSLPrivateKey      => OpenSSL::PKey::RSA.new(          File.open(File.join(CERT_PATH, "server.key")).read),
        :SSLCertName        => [ [ "CN",WEBrick::Utils::getservername ] ]
}

Signal.trap('INT') {
  Rack::Handler::WEBrick.shutdown
} 

Rack::Handler::WEBrick.run CheckinServer, webrick_options
