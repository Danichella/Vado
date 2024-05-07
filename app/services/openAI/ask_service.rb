module OpenAI
  class AskService < BaseService
    attr_reader :client

    def initialize(chat)
      super(chat)
      init_client
    end

    def call
      make_request
    end

    private

    def init_client
      @client = ::OpenAI::Client.new(
        access_token: ENV.fetch('OPENAI_API_KEY'),
        log_errors: true
      )
    end

    def make_request
      client.chat(parameters: {
                    model: 'gpt-3.5-turbo',
                    messages:,
                    tools:,
                    tool_choice: 'auto'
                  })
    end

    def messages
      chat.messages.map do |item|
        result = {
          role: item.role,
          content: item.content
        }

        if item.role == 'function'
          result[:tool_call_id] = item.tool_call_id
          result[:name] = item.tool_name
        end

        result
      end
    end

    def tools
      [
        {
          type: 'function',
          function: {
            name: 'get_current_weather',
            description: 'This functions returns today weather info'
          }
        },
        {
          type: 'function',
          function: {
            name: 'get_daily_weather',
            description: 'This functions returns today weather info',
            parameters: {
              type: 'object',
              properties: {
                start_date: {
                  type: 'string',
                  description: 'The start time of interval to get weather data. A day must be specified as an ISO8601 date (e.g. 2022-06-30).'
                },
                end_date: {
                  type: 'string',
                  description: 'The end time of interval to get weather data. A day must be specified as an ISO8601 date (e.g. 2022-06-30).'
                }
              },
              required: %w[start_date end_date]
            }
          }
        }
      ]
    end
  end
end
