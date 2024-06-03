# frozen_string_literal: true

module OpenAI
  class BuildResponseService < BaseService
    def call
      requests = 0
      should_continue = true
      while should_continue && requests < 5
        response = make_request

        next unless response

        should_continue = process_request?(response)
        requests += 1
      end
    end

    private

    def make_request
      AskService.new(chat).call
    rescue StandardError => e
      handle_assistant_error(e)
      nil
    end

    def process_request?(response)
      data = response.fetch('choices', [])[0]['message']

      return false if data.blank?

      if data['tool_calls'].present?
        data['tool_calls'].each do |tool_call|
          content = perform_action(tool_call['function'])
          chat.messages.create(
            role: 'function',
            tool_call_id: tool_call['id'],
            tool_name: tool_call['function']['name'],
            content:
          )
        end

        return true
      end

      return false if data['content'].blank?

      chat.messages.create(
        role: data['role'],
        content: data['content']
      )

      false
    end

    def perform_action(action_args)
      Actions::PerformActionService.new(chat.user, action_args.deep_symbolize_keys).call
    end

    def handle_assistant_error(error)
      Rails.logger.error(error)
      chat.messages.create(role: 'assistant', content: error.to_json)
    end
  end
end
