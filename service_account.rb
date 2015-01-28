require 'oauth2'
require 'legato'
require 'google/api_client'
require 'active_support/all' # => for expires_in time duration
require 'pry'

class ServiceAccount
  attr_reader :user

  def initialize
    refresh!
  end

  def profile
    refresh! if token_expired?
    @user.profiles.first # .first just for now?
  end

  def token_expired?
    @user && @user.access_token.expired?
  end

  def refresh!
    @token = new_access_token
    @user = Legato::User.new(@token)
  end

  def new_access_token
    scope = "https://www.googleapis.com/auth/analytics.readonly"
    email = "400474684363-2pf5val9c3jq52up3utf3lkr7ulkita5@developer.gserviceaccount.com"

    # TODO: where to keep this safe?
    pk_filename = "#{Dir.home}/Desktop/Analytics Reporting-df2964f820a6.p12"

    client = Google::APIClient.new(
      application_name: "Analytics Reporting",
      application_version: "1"
    )

    key = Google::APIClient::PKCS12.load_key(pk_filename, "notasecret")
    service_account = Google::APIClient::JWTAsserter.new(email, scope, key)
    client.authorization = service_account.authorize

    oauth_client = OAuth2::Client.new("", "", {
      authorize_url: 'https://accounts.google.com/o/oauth2/auth',
      token_url: 'https://accounts.google.com/o/oauth2/token'
    })

    OAuth2::AccessToken.new(
      oauth_client,
      client.authorization.access_token,
      expires_in: 1.hour
    )
  end
end
