# frozen_string_literal: true

module OpenAI
  class ClientService
    attr_reader :client

    def initialize
      init_client
    end

    private

    def init_client
      @client = ::OpenAI::Client.new(
        access_token: ENV.fetch('OPENAI_API_KEY'),
        log_errors: true
      )
    end
  end
end
