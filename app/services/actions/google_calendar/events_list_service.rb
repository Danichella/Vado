# frozen_string_literal: true

module Actions
  module GoogleCalendar
    class EventsListService < BaseService
      def call
        serialize_events(list_of_events)
      end

      private

      def list_of_events
        result = []
        next_page = nil
        next_page_exist = true

        while next_page_exist
          response = JSON.parse(
            connection.get('calendars/primary/events', query_params(next_page)).body
          )
          result << response['items']
          next_page = response['nextSyncToken']
          next_page_exist = next_page.present?
        end

        result.flatten.compact
      end

      def serialize_events(data)
        return [] if data.blank?

        data.map do |event|
          {
            summary: event['summary'],
            creator: event['creator'],
            start: event['start'].slice('date', 'dateTime'),
            end: event['end'].slice('date', 'dateTime'),
            recurrence: event['recurrence']
          }
        end
      end

      def query_params(page_token)
        result = {
          maxResults: 100,
          page_token:
        }

        result[:timeZone] = user.settings.timezone if user.settings.timezone
        result[:timeMin] = arguments['start_date'] if arguments['start_date'].present?
        result[:timeMax] = arguments['end_date'] if arguments['end_date'].present?

        result
      end
    end
  end
end
