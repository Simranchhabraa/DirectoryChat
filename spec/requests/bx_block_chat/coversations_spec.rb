require 'rails_helper'

RSpec.describe BxBlockChat::ConversationsController, type: :controller do
  describe 'POST #create' do
    let!(:user1) { FactoryBot.create(:user) } 
    let!(:user2) { FactoryBot.create(:user) }

    context 'when conversation between sender and recipient exists' do
      let!(:existing_conversation) { FactoryBot.create(:conversation, sender: user1, recipient: user2) }
      it 'does not create a new conversation' do
        expect {
          post :create, params: { sender_id: user1.id, recipient_id: user2.id }
        }.to_not change(Conversation, :count)
      end
      it 'returns a JSON response with the existing conversation' do
        post :create, params: { sender_id: user1.id, recipient_id: user2.id }
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['id']).to eq(existing_conversation.id)
      end
      it 'returns a 200 status code' do
        post :create, params: { sender_id: user1.id, recipient_id: user2.id }
        expect(response).to have_http_status(200)
      end
    end
    context 'when conversation between sender and recipient does not exist' do
      it 'creates a new conversation' do
        expect {
          post :create, params: { sender_id: user1.id, recipient_id: user2.id }
        }.to change(Conversation, :count).by(1)
      end
      it 'returns a JSON response with the new conversation' do
        post :create, params: { sender_id: user1.id, recipient_id: user2.id }
        parsed_response = JSON.parse(response.body)
        new_conversation = Conversation.last
        expect(parsed_response).to include(
          'id' => new_conversation.id,
          'sender_id' => new_conversation.sender_id,
          'recipient_id' => new_conversation.recipient_id)
        # expect(parsed_response['id']).to eq(Conversation.last.id)
      end
      it 'returns a 200 status code' do
        post :create, params: { sender_id: user1.id, recipient_id: user2.id }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET #information' do
    let(:user) { FactoryBot.create(:user) } 
    it 'returns user information as JSON' do
      get :information, params: { id: user.id }
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['id']).to eq(user.id)
    end
    it 'returns a 200 status code' do
      get :information, params: { id: user.id }
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #userchat' do
    let!(:user) { FactoryBot.create(:user) } 
    let!(:conversation) { FactoryBot.create(:conversation, sender: user, user_id: user.id) } 

    context 'when user has conversations' do
      let!(:message1) { FactoryBot.create(:message, conversation: conversation, body: "Hello") }
      let!(:message2) { FactoryBot.create(:message, conversation: conversation, body: "hi") }
      it 'returns user chat messages as JSON' do
        post :userchat, params: { id: user.id }
        parsed_response = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(parsed_response['users']['name']).to eq(user.firstname)
        expect(parsed_response['users']['profile_picture']).to eq(user.image)
        expect(parsed_response['users']['type']).to eq(user.type)
        expect(parsed_response['chat']).to be_an(Array)
        expect(parsed_response['chat'].length).to eq(2)
        expect(parsed_response['chat'][0]['body']).to eq(message1.body)
        expect(parsed_response['chat'][0]['date']).to eq(message1.created_at.strftime('%Y-%m-%d'))
        expect(parsed_response['chat'][0]['time']).to eq(message1.created_at.strftime('%H:%M:%S'))
      end
      it 'returns a 200 status code' do
        post :userchat, params: { id: user.id }
        expect(response).to have_http_status(200)
      end
    end

    context 'when user has no conversations' do
      it 'returns user information with an empty chat array as JSON' do
        get :userchat, params: { id: user.id }
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['users']['name']).to eq(user.firstname)
        expect(parsed_response['users']['profile_picture']).to eq(user.image)
        expect(parsed_response['users']['type']).to eq(user.type)
        expect(parsed_response['chat']).to be_empty
      end
      it 'returns a 200 status code' do
        get :userchat, params: { id: user.id }
        expect(response).to have_http_status(200)
      end
    end
  end   
end
