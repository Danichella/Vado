module OpenAI
  class BuildResponseService < BaseService
    def call
      should_continue = true
      until should_continue
        response = make_request

        next unless response

        should_continue = process_request(response)
      end
    end

    private

    def make_request
      AskService.new(chat).call
    rescue error
      handle_assistant_error(error)
      nil
    end

    def process_request?(response)
      data = response.dig('choices', '0', 'message')

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
      Actions::PerformAction.new(action_args.deep_symbolize_keys).call
    end

    def handle_assistant_error(error)
      Rails.logger.error(error)
      chat.messages.create(role: 'assistant', content: error.to_json)
    end
  end
end
