# frozen_string_literal: true

module Actions
  class PerformActionService < BaseActionService
    FUNCTIONS_TO_SERVICE_MAP = {
      get_current_weather: Actions::WeatherForecastService,
      get_daily_weather: Actions::WeatherForecastService
    }.freeze

    def call
      service = FUNCTIONS_TO_SERVICE_MAP[options[:name].to_sym]

      return no_service_error if service.nil?

      begin
        service.new(user, options).call.to_json
      rescue e => e
        e.to_json
      end
    end

    private

    def no_service_error
      'Could not find function to call. Please check if this function present in tolls list'
    end
  end
end
