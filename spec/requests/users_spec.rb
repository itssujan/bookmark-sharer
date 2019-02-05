require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:users) { create_list(:user, 10) }
  let(:user_id) { users.first.id }

  describe 'GET /users' do
    before { get '/users' }

    it 'returns users' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns 200 status code' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'CREATE /users' do

    context "when all parameters are passed" do
      before(:each) do
        user_params = { first_name: "john", last_name: "doe", email: 'johndoe@johndoe.com' }
        post '/users', params: user_params
      end

      it 'returns creates user when params are passed' do
        expect(json["first_name"]).to eq("john")
        expect(json["last_name"]).to eq("doe")
        expect(json["email"]).to eq("johndoe@johndoe.com")
      end

      it 'returns 201 status code' do
        expect(response).to have_http_status(201)
      end
    end

    context "when first_name is not passed" do
      before(:each) do
        user_params = { last_name: "doe", email: 'johndoe@johndoe.com' }
        post '/users', params: user_params
      end

      it "throws a missing first_name exception" do
        expect(json["message"]).to eq("Validation failed: First name can't be blank")
      end
    end

    context "when email is not passed" do
      before(:each) do
        user_params = { first_name: "john", last_name: "doe" }
        post '/users', params: user_params
      end

      it "throws a missing first_name exception" do
        expect(json["message"]).to eq("Validation failed: Email can't be blank, Email is invalid")
      end
    end

    context "when email is not unique" do
      before(:each) do
        user_params = { first_name: "john", last_name: "doe", email: 'johndoe@johndoe.com' }
        post '/users', params: user_params
      end

      it "throws a missing first_name exception" do
        user_params = { first_name: "john", last_name: "doe", email: 'johndoe@johndoe.com' }
        post '/users', params: user_params
        expect(json["message"]).to eq("Validation failed: Email has already been taken")
      end
    end

  end

end
