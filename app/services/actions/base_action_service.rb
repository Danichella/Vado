# frozen_string_literal: true

module Actions
  class BaseActionService
    attr_accessor :options

    def initialize(options = {})
      @options = options
    end

    def call
      raise NotImplementedError
    end
  end
end
