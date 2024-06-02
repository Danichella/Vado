# frozen_string_literal: true

class Api::V1::MessagesController < Api::V1::ApplicationController
  before_action :find_message, only: [:destroy, :build_response, :voice_response]

  def index
    messages = current_user.messages.where(
      role: %w[user assistant]
    ).order(created_at: :desc).limit(20)

    render_serializable_json(
      messages, { status: :ok }
    )
  end

  def create
    if params[:voice_record].present?
      params[:content] = OpenAI::SpeechToTextService.new(params[:voice_record]).call
    end

    message = chat.messages.new(message_params)

    if message.save
      render_serializable_json(message, { status: :created })
    else
      render_error(422, message.errors.full_messages.to_sentence)
    end
  end

  def build_response
    chat = @message.chat

    OpenAI::BuildResponseService.new(chat).call

    messages = chat.messages.where(
      'created_at > ?', @message.created_at
    ).where(
      role: 'assistant'
    ).order(created_at: :asc)

    if messages.count.positive?
      render_serializable_json(messages, { status: :ok })
    else
      render_error(422, 'Response not received')
    end
  end

  def voice_response
    voice_file_url = OpenAI::TextToSpeechService.new(@message).call

    if voice_file_url.present?
      render json: { url: voice_file_url }, status: :ok
    else
      render json: { error: 'Cannot proceed this action' }, status: :unprocessable_entity
    end
  end

  def destroy
    if @message.destroy
      render_serializable_json(
        @message, {
          status: :deleted
        }
      )
    else
      render_error(422, @message.errors.full_messages.to_sentence)
    end
  end

  private

  def chat
    @chat = current_user.chats.where(
      'created_at >= ?', 30.minutes.ago
    ).order(created_at: :desc).first

    @chat ||= current_user.chats.create
  end

  def find_message
    @message = current_user.messages.find_by(id: params[:id])

    render_error(404, 'Message not found') and return unless @message
  end

  def message_params
    params.permit(:content).merge(role: 'user')
  end

  def render_serializable_json(data, options)
    options[:serializer] = MessageSerializer

    super(data, options)
  end
end
