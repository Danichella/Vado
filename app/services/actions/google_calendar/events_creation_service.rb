# frozen_string_literal: true

module Actions
  module GoogleCalendar
    class EventsCreationService < BaseService
      def call
        prepare_response(create_event)
      end

      private

      def create_event
        response = connection.post(url, body)

        unless response.status == 200
          raise StandardError, JSON.parse(response.body).dig(
            'error', 'message'
          )
        end

        JSON.parse(response.body)
      end

      def prepare_response(response)
        {
          status: 'Successfully created',
          html_link: response['htmlLink']
        }
      end

      def url
        "calendars/primary/events?conferenceDataVersion=1&sendNotifications=#{
          arguments['attendee_emails'].present?
        }"
      end

      def body
        {
          start: date_field('start_date', 'start_date_time'),
          end: date_field('end_date', 'end_date_time'),
          summary: arguments.fetch('title', nil),
          description: arguments.fetch('description', nil),
          attendees:,
          conferenceData: conference_data
        }.to_json
      end

      def date_field(date, date_time)
        date_time = arguments.fetch(date_time, nil)
        date = arguments.fetch(date, nil)
        return {} unless date || date_time

        result = {}
        if date.present?
          result[:date] = date
        else
          result[:dateTime] = date_time
        end
        result[:timeZone] = user.settings.timezone if user.settings.timezone.present?

        result
      end

      def attendees
        attendee_emails = arguments.fetch('attendee_emails', nil)
        return unless attendee_emails

        attendee_emails.map { |email| { email: } }
      end

      def conference_data
        return unless arguments.fetch('attendee_emails', nil)

        {
          createRequest: {
            requestId: SecureRandom.uuid,
            conferenceSolutionKey: {
              type: 'hangoutsMeet'
            }
          }
        }
      end
    end
  end
end
