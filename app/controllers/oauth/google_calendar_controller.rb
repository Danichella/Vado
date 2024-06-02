# frozen_string_literal: true

class Oauth::GoogleCalendarController < ApplicationController
  def redirect
    client = Signet::OAuth2::Client.new(client_options)

    redirect_to client.authorization_uri.to_s, allow_other_host: true
  end

  def callback
    client = Signet::OAuth2::Client.new(client_options)
    client.code = params[:code]

    response = client.fetch_access_token!

    current_user = find_user
    return head :unprocessable_entity unless current_user

    connection = current_user.connections.find_or_create_by(provider: 'google_calendar')

    if connection.update(connection_params(response))
      @response_text = 'Ви успішно авторизувалися! Можете закрити вікно'
    else
      error_message = connection.errors.full_messages.to_sentence
      connection.destroy
      @response_text = "Помилка при спробі авторизуватися: #{error_message}"
    end

    render template: 'oauth/callback', locals: { response_text: @response_text }
  end

  private

  def client_options
    {
      client_id: ENV.fetch('GOOGLE_CLIENT_ID', nil),
      client_secret: ENV.fetch('GOOGLE_CLIENT_SECRET', nil),
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR_EVENTS,
      redirect_uri: callback_oauth_google_calendar_index_url,
      state: params.permit(:user_email).to_json
    }
  end

  def find_user
    user_email = JSON.parse(params[:state]).fetch('user_email', nil)

    User.find_by(email: user_email)
  end

  def connection_params(response)
    result = response.slice('access_token', 'refresh_token', 'expires_in')
    result['expires_in'] = Time.zone.now + result['expires_in'].seconds

    result
  end
end
