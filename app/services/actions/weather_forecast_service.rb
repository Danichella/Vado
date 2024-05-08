# frozen_string_literal: true

module Actions
  class WeatherForecastService < BaseActionService
    BASE_URL = 'https://api.open-meteo.com/'

    def call
      function_name = options.fetch(:name)
      arguments = JSON.parse(options.fetch(:arguments, '{}'))

      case function_name
      when 'get_current_weather'
        current_weather
      when 'get_daily_weather'
        daily_weather(arguments)
      else
        raise no_function_error
      end
    end

    private

    def current_weather
      query_params = {
        current: 'temperature_2m,relative_humidity_2m,apparent_temperature,is_day,' \
                 'precipitation,rain,showers,snowfall,weather_code,cloud_cover,' \
                 'pressure_msl,surface_pressure,wind_speed_10m,wind_direction_10m,' \
                 'wind_gusts_10m'
      }

      response = make_request(query_params)

      {
        current: response['current'],
        current_units: response['current_units']
      }
    end

    def daily_weather(arguments)
      query_params = {
        daily: 'weather_code,temperature_2m_max,temperature_2m_min,apparent_temperature_max,' \
               'apparent_temperature_min,sunrise,sunset,daylight_duration,sunshine_duration,' \
               'wind_speed_10m_max,wind_gusts_10m_max,wind_direction_10m_dominant',
        start_date: arguments['start_date'],
        end_date: arguments['end_date']
      }

      response = make_request(query_params)

      {
        daily: convert_to_json_structure(response['daily']),
        daily_units: response['daily_units']
      }
    end

    def convert_to_json_structure(data)
      result = []

      data.each do |key, value|
        value.each_with_index do |item, index|
          result[index] ||= {}

          result[index][key] = item
        end
      end

      result
    end

    def make_request(query_params)
      connection = Faraday.new(
        url: BASE_URL,
        params: {
          latitude: 49.84,
          longitude: 24.03,
          timezone: 'EET'
        }
      )

      JSON.parse(
        connection.get('v1/forecast', query_params, nil).body
      )
    end

    def no_function_error
      StandardError.new(
        'Could not find function to call. Please check if this function present in tolls list'
      )
    end
  end
end
