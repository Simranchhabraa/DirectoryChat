module BxBlockChat
 class MessagesController < ApplicationController
  protect_from_forgery with: :null_session
      before_action do
          @conversation = Conversation.find(params[:conversation_id])
      end
      def create
        @message = @conversation.messages.new(message_params)
        if @message.save
          render json: @message
        else
          render json: { error: "Failed to create message" }, status: :unprocessable_entity
        end
      end

      private
      def message_params
        params.require(:message).permit(:body, :user_id, :conversation_id)
        end
  end
end