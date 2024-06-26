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
          content: "Current time: #{Time.zone.now}. If needed add links to response text using " \
                   'markdown style (e.g. [text](https://example.com))'
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
        },
        {
          type: 'function',
          function: {
            name: 'create_calendar_event',
            description: "This functions creates event in user's personal google calendar",
            parameters: {
              type: 'object',
              properties: {
                start_date_time: {
                  type: 'string',
                  description: 'The start date time of event. A value must be specified' \
                               'as an ISO dateTime (e.g. 2024-04-30T00:00:00).'
                },
                end_date_time: {
                  type: 'string',
                  description: 'The end date time of event. A value must be specified' \
                               'as an ISO dateTime (e.g. 2024-04-30T00:00:00).'
                },
                start_date: {
                  type: 'string',
                  description: 'The start date of event. This property should be used if user ' \
                               'does not specify time. A value must be specified as an ISO8601' \
                               'date (e.g. 2024-04-30).'
                },
                end_date: {
                  type: 'string',
                  description: 'The end date of event. This property should be used if user ' \
                               'does not specify time. This parameter required if start date ' \
                               'present. A value must be specified as an ISO8601 ' \
                               'date (e.g. 2024-04-30).'
                },
                attendee_emails: {
                  type: 'array',
                  description: 'The emails of users that must be added to event.',
                  items: {
                    type: 'string'
                  }
                },
                title: {
                  type: 'string',
                  description: 'The title of event.'
                },
                description: {
                  type: 'string',
                  description: 'The description of event.'
                }
              },
              required: %w[start_date_time end_date_time]
            }
          }
        },
        {
          type: 'function',
          function: {
            name: 'build_maps_route',
            description: "This functions return route build to destination from user's location",
            parameters: {
              type: 'object',
              properties: {
                destination_address: {
                  type: 'string',
                  description: 'The address query used to build route'
                },
                departure_time: {
                  type: 'string',
                  description: "The user's departure time from current location. A value must be " \
                               'specified as an ISO dateTime (e.g. 2024-04-30T00:00:00Z).'
                },
                arrival_time: {
                  type: 'string',
                  description: "The user's arrival time to destination. A value must be specified" \
                               'as an ISO dateTime (e.g. 2024-04-30T00:00:00Z).'
                },
                travel_mode: {
                  type: 'string',
                  description: 'The start travel transport type. ' \
                               'TRANSIT mean travel by public transport',
                  enum: %w[DRIVE BICYCLE WALK TRANSIT]
                }
              },
              required: %w[destination_address]
            }
          }
        }
      ]
    end
  end
end
