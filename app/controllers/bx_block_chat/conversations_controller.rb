module BxBlockChat
  class ConversationsController < ApplicationController
    protect_from_forgery with: :null_session

    def create  
      # debugger
      if Conversation.between(params[:sender_id], params[:recipient_id]).present? 
        @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first
      else
        @conversation = Conversation.create!(conversation_params)
      end
      render json: @conversation
    end

    def information 
      @user = User.find(params[:id])
      render json: @user
    end

    def userchat
      @user = User.find(params[:id])
      users_data ={
        name: @user.firstname,
        profile_picture: @user.image,
        type: @user.type
      }
      if @user.conversations.any?
      @conversation = Conversation.find(params[:id])
      messages_with_timestamps = @conversation.messages.map do |message|
        {
          body: message.body,
          date: message.created_at.strftime('%Y-%m-%d'),
          time: message.created_at.strftime('%H:%M:%S')
        }
      end
  
      render json: { users: users_data, chat: messages_with_timestamps }
    else
      render json: { users: users_data, chat: [] }
    end
    end
    private
    def conversation_params
      params.permit(:sender_id, :recipient_id)
    end
  end
end