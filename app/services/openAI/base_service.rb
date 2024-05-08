# frozen_string_literal: true

module OpenAI
  class BaseService
    attr_reader :chat

    def initialize(chat)
      @chat = chat
    end
  end
end
