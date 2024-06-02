# frozen_string_literal: true

module Oauth
  class GoogleAccessTokenService
    attr_accessor :connection

    def initialize(user, provider)
      @connection = user.connections.find_by(provider:)
    end

    def self.get_access_token(user, provider)
      new(user, provider).call
    end

    def call
      return if @connection.nil?

      refresh_access_token if access_token_expired?
      # refresh_access_token

      @connection.reload.access_token
    end

    private

    def access_token_expired?
      Time.zone.now > @connection.expires_in
    end

    def refresh_access_token
      client = Signet::OAuth2::Client.new(client_options)

      response = client.fetch_access_token!.slice('access_token', 'expires_in')

      response['expires_in'] = Time.zone.now + response['expires_in'].seconds

      @connection.update(access_token: response['access_token'], expires_in: response['expires_in'])
    end

    def client_options
      {
        client_id: ENV.fetch('GOOGLE_CLIENT_ID', nil),
        client_secret: ENV.fetch('GOOGLE_CLIENT_SECRET', nil),
        token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
        refresh_token: @connection.refresh_token
      }
    end
  end
end
