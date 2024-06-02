# frozen_string_literal: true

module Actions
  class BaseActionService
    attr_accessor :options, :user

    def initialize(user, options = {})
      @user = user
      @options = options
    end

    def call
      raise NotImplementedError
    end
  end
end
