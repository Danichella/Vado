# frozen_string_literal: true

module Actions
  class BaseActionService
    attr_accessor :options, :user, :arguments

    def initialize(user, options = {})
      @user = user
      @options = options
      @arguments = JSON.parse(options.fetch(:arguments, '{}'))
    end

    def call
      raise NotImplementedError
    end
  end
end
