# frozen_string_literal: true

module OpenAI
  class SpeechToTextService < ClientService
    attr_reader :voice_record

    def initialize(voice_record)
      super()
      @voice_record = voice_record
    end

    def call
      make_request.fetch('text', nil)
    end

    private

    def make_request
      client.audio.transcribe(
        parameters: {
          model: 'whisper-1',
          file: File.open(voice_record, 'rb'),
          language: 'uk'
        }
      )
    end
  end
end
