# frozen_string_literal: true

module Actions
  module GoogleCalendar
    class BaseService < BaseActionService
      BASE_URL = 'https://www.googleapis.com/calendar/v3/'

      def connection
        @connection ||= Faraday.new(
          url: BASE_URL,
          headers:
        )
      end

      private

      def headers
        @access_token ||= Oauth::GoogleAccessTokenService.get_access_token(user, 'google_calendar')

        { Authorization: "Bearer #{@access_token}" }
      end
    end
  end
end
