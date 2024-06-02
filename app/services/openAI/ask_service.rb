# frozen_string_literal: true

module OpenAI
  class AskService < ClientService
    attr_reader :chat

    def initialize(chat)
      super()
      @chat = chat
    end

    def call
      make_request
    end

    private

    def make_request
      client.chat(parameters: {
                    model: 'gpt-3.5-turbo',
                    messages:,
                    tools:,
                    tool_choice: 'auto'
                  })
    end

    def messages
      result = chat.messages.map do |item|
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

      result.unshift(
        {
          role: 'system',
          content: "Current time: #{Time.zone.now}"
        }
      )
      result
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
                  description: 'The start time of interval to get weather data. A day must be ' \
                               'specified as an ISO8601 date (e.g. 2024-04-30).'
                },
                end_date: {
                  type: 'string',
                  description: 'The end time of interval to get weather data. A day must be ' \
                               'specified as an ISO8601 date (e.g. 2024-04-30).'
                }
              },
              required: %w[start_date end_date]
            }
          }
        },
        {
          type: 'function',
          function: {
            name: 'get_calendar_events',
            description: "This functions returns events from user's personal google calendar",
            parameters: {
              type: 'object',
              properties: {
                start_date: {
                  type: 'string',
                  description: 'The start time of interval to get events from calendar. A value' \
                               'must be specified as an ISO dateTime ' \
                               '(e.g. 2024-04-30T00:00:00.000Z).'
                },
                end_date: {
                  type: 'string',
                  description: 'The end time of interval to get events from calendar. A value' \
                               'must be specified as an ISO dateTime ' \
                               '(e.g. 2024-04-30T00:00:00.000Z).'
                }
              },
              required: %w[start_date]
            }
          }
        }
      ]
    end
  end
end
