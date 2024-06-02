# frozen_string_literal: true

require 'stringio'

module OpenAI
  class TextToSpeechService < ClientService
    include Rails.application.routes.url_helpers

    attr_reader :message

    def initialize(message)
      super()
      @message = message
    end

    def call
      response = make_request
      io = StringIO.new(response)

      blob = ActiveStorage::Blob.create_and_upload!(
        io:,
        filename: "response_#{message.id}.aac",
        content_type: 'audio/aac'
      )
      url_for(blob)
    end

    private

    def make_request
      client.audio.speech(
        parameters: {
          model: 'tts-1-hd',
          input: message.content,
          voice: 'alloy',
          response_format: 'aac'
        }
      )
    end
  end
end
