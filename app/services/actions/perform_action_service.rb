module Actions
  class PerformActionService < BaseActionService
    FUNCTIONS_TO_SERVICE_MAP = {
      get_current_weather: Actions::WeatherActionsService
    }

    def call
      service = FUNCTIONS_TO_SERVICE_MAP[options[:name]]

      return no_service_error if service.nil?

      begin
        service.new(options).call.to_json
      rescue error
        error.to_json
      end
    end

    private

    def no_service_error
      'Could not find function to call. Please check if this function present in tolls list'
    end
  end
end
