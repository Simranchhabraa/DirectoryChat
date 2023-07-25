require 'rails_helper'

# spec/controllers/bx_block_admin/users_controller_spec.rb
RSpec.describe BxBlockAdmin::UsersController, type: :controller do
  describe "GET #index" do
    it "returns a JSON list of users" do
      # Create some user records using FactoryBot or fixtures
      users = FactoryBot.create_list(:user, 5)

      get :index

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("application/json")
      response_data = JSON.parse(response.body)

      # Check the structure and content of the response
      expect(response_data).to be_an(Array)
      expect(response_data.size).to eq(5)

      # Check the attributes of the first user in the response
      expect(response_data[0]['name']).to eq(users[0].firstname)
      expect(response_data[0]['profile_picture']).to eq(users[0].image)
      expect(response_data[0]['type']).to eq(users[0].type)

      # Check the attributes of the second user in the response
      expect(response_data[1]['name']).to eq(users[1].firstname)
      expect(response_data[1]['profile_picture']).to eq(users[1].image)
      expect(response_data[1]['type']).to eq(users[1].type)
    end
  end

  describe "POST #create" do
    it "creates a new user" do
      user_params = FactoryBot.attributes_for(:user)

      expect {
        post :create, params: { user: user_params }
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(response.content_type).to include("application/json")
      response_json = JSON.parse(response.body)
      expect(response_json["user"]["firstname"]).to eq(user_params[:firstname])
      expect(response_json["user"]["lastname"]).to eq(user_params[:lastname])
      expect(response_json["message"]).to eq("User was successfully created.")
    end

    it "returns an error for invalid user data" do
      invalid_user_params = { firstname: "", lastname: "", email: "invalid_email" }

      post :create, params: { user: invalid_user_params }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to include("application/json")
      response_json = JSON.parse(response.body)

      expect(response_json["errors"]).to include("Email is invalid")
      expect(response_json["errors"]).to include("Password can't be blank")
   end
  end

  describe "GET #search_users" do
    it "returns matching users based on search query" do
      user1 = FactoryBot.create(:user, firstname: "John", lastname: "Doe")
      user2 = FactoryBot.create(:user, firstname: "Jane", lastname: "Smith")
      user3 = FactoryBot.create(:user, firstname: "Jane", lastname: "Doe")
      user4 = FactoryBot.create(:user, firstname: "Jane", lastname: "Smith")
  
      get :search_users, params: { query: "John" }
  
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("application/json")
      response_json = JSON.parse(response.body)
      expect(response_json).to be_an(Array)
      expect(response_json.size).to eq(1)
      expect(response_json).to include(
        {
          "firstname" => user1.firstname,
          "id" => user1.id,
          "lastname" => user1.lastname,
          "image" => user1.image,
          "type" => user1.type
        })
        expect(response_json).not_to include(
        {
          "firstname" => user2.firstname,
          "id" => user2.id,
          "lastname" => user2.lastname,
          "image" => user2.image,
          "type" => user2.type
        },
        {
          "firstname" => user3.firstname,
          "id" => user3.id,
          "lastname" => user3.lastname,
          "image" => user3.image,
          "type" => user3.type
        },
        {
          "firstname" => user4.firstname,
          "id" => user4.id,
          "lastname" => user4.lastname,
          "image" => user4.image,
          "type" => user4.type
        }
      )
    end
  
    it "returns an error if the search query is empty" do
      get :search_users, params: { query: "" }
  
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to include("application/json")
      response_json = JSON.parse(response.body)
  
      expect(response_json).to eq({ "error" => "Search query cannot be empty" })
    end
  end
end
