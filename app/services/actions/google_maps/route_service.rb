# frozen_string_literal: true

module Actions
  module GoogleMaps
    class RouteService < BaseActionService
      BASE_URL = 'https://routes.googleapis.com'

      def call
        prepare_response(build_route)
      end

      private

      def build_route
        response_body = connection.post('/directions/v2:computeRoutes', body).body

        raise build_route_error if response_body.blank?

        JSON.parse(response_body)
      end

      def prepare_response(data)
        destination_data = legs_data(data)&.dig('endLocation', 'latLng')
        origin_data = legs_data(data)&.dig('startLocation', 'latLng')
        query_options = {
          destination: destination_data.map { |_, value| value }.join(','),
          origin: origin_data.map { |_, value| value }.join(',')
        }.to_query
        html_link = "https://www.google.com/maps/dir/?api=1&#{query_options}"

        {
          html_link:,
          localized_values: data['routes']&.first&.dig('localizedValues')&.slice(
            'distance',
            'duration',
            'transitFare'
          )
        }
      end

      def legs_data(data)
        @legs_data ||= data['routes']&.first&.dig('legs')&.first
      end

      def body
        {
          languageCode: 'uk',
          origin: { location: { latLng: user.settings.location } },
          destination: { address: arguments.fetch('destination_address', nil) },
          departureTime: arguments.fetch('departure_time', nil),
          arrivalTime: arguments.fetch('arrival_time', nil),
          travelMode: travel_mode,
          routingPreference: routing_preference
        }.to_json
      end

      def travel_mode
        mode = arguments.fetch('travel_mode', nil)
        return if mode.blank? ||
                  arguments.fetch('departure_time', nil).present? ||
                  arguments.fetch('arrival_time', nil).present?

        mode
      end

      def routing_preference
        return if arguments.fetch('travel_mode', nil) != 'DRIVE'

        'TRAFFIC_AWARE'
      end

      def connection
        Faraday.new(
          url: BASE_URL,
          params: { key: ENV.fetch('GOOGLE_MAPS_API_KEY', nil) },
          headers:
        )
      end

      def headers
        { 'X-Goog-FieldMask': 'routes.legs,routes.localizedValues',
          'Content-Type': 'application/json' }
      end

      def build_route_error
        StandardError.new(
          'Route cannot be created. Invalid arguments or incorrect destination_address.'
        )
      end
    end
  end
end
