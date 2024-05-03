class Api::V1::MessagesController < Api::V1::ApplicationController
  before_action :find_chat
  before_action :find_message, only: [:show, :update, :destroy]

  def index
    message = @chat.messages

    render_serializable_json(
      message, { status: :ok }
    )
  end

  def show
    render_serializable_json(
      @message, { status: :ok }
    )
  end

  def create
    message = @chat.messages.new(message_params)

    if message.save
      render_serializable_json(
        message, { status: :created }
      )
    else
      render_error(422, message.errors.full_messages.to_sentence)
    end
  end

  def update
    if @message.update(chat_params)
      render_serializable_json(
        @message, {
          status: :ok
        }
      )
    else
      render_error(422, @message.errors.full_messages.to_sentence)
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

  def find_chat
    @chat = current_user.chats.find_by(id: params[:chat_id])

    render_not_found_error('Chat') and return unless @chat
  end

  def find_message
    @message = @chat.messages.find_by(id: params[:id])

    render_not_found_error('Message') and return unless @message
  end

  def message_params
    params.permit(:text)
  end

  def render_not_found_error(item)
    render_error(404, "#{item} not found")
  end

  def render_serializable_json(data, options)
    options[:serializer] = MessageSerializer

    super(data, options)
  end
end
