require 'rails_helper'

RSpec.describe BxBlockChat::MessagesController, type: :controller do
  let!(:conversation) { FactoryBot.create(:conversation) }
  let!(:user) { FactoryBot.create(:user) }
  describe "POST #create" do
    context "with valid message parameters" do
      it "creates a new message" do
        post :create, params: { user_id: user.id, conversation_id: conversation.id, body: "Hello, this is a test message"}
  
        response_json = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(response_json['body']).to eq('Hello, this is a test message')
        expect(response_json['user_id']).to eq(user.id)
        expect(response_json['conversation_id']).to eq(conversation.id)
        expect(response_json['created_at']).to be_present
      end
    end
  
    context "with invalid message parameters" do
      it "returns an error" do
        post :create, params: { user_id: user.id, conversation_id: conversation.id, body: ""}
  
        response_json = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_json).to include("error" => "Failed to create message")
      end
    end
  end
end
