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
    before { User.destroy_all }
    user_params = { first_name: 'john', last_name: 'doe', email: 'johndoe@johndoe.com' }

    it 'creates user with valid user params' do
      expect { post '/users', params: user_params }.to change { User.count }.from(0).to(1)
    end

    it 'returns 201 status code' do
      post '/users', params: user_params
      expect(response).to have_http_status(201)
    end

    it 'throws a missing first_name exception' do
      user_params = {last_name: 'doe', email: 'johndoe@johndoe.com' }
      post '/users', params: user_params
      expect(json['message']).to eq("Validation failed: First name can't be blank")
    end

    it 'throws a missing first_name exception' do
      user_params = { first_name: 'john', last_name: 'doe'}
      post '/users', params: user_params
      expect(json['message']).to eq("Validation failed: Email can't be blank, Email is invalid")
    end

    it 'should have unique email' do
      2.times do
        user_params = { first_name: 'john', last_name: 'doe', email: 'johndoe@johndoe.com' }
        post '/users', params: user_params
      end
      expect(json['message']).to eq('Validation failed: Email has already been taken')
    end
  end

  describe 'GET /Users/:id' do
    it 'returns a user when called with a valid userid' do
      get "/users/#{user_id}"
      expect(json['id']).to eq(user_id)
      expect(json['email']).to eq(users.first.email)
    end

    it 'does not return any user when called with an invalid userid' do
      tmp_user_id = SecureRandom.random_number(100)
      get "/users/#{tmp_user_id}"
      expect(json['message']).to eq("Couldn't find User with 'id'=#{tmp_user_id}")
    end
  end

  describe 'PUT /users/:id' do
    # shouldnt do anything for an invalid user
    it 'updates a user' do
      user_params = { first_name: 'john', last_name: 'doe' }
      put "/users/#{user_id}", params: user_params
      expect(response).to have_http_status(204)
    end

    it 'should not update an invalid user' do
      user_params = { first_name: 'john', last_name: 'doe', email: 'johndoe@johndoe.com' }
      put "/users/#{SecureRandom.random_number(100)}", params: user_params
      expect(response).to have_http_status(404)
    end
  end

  describe 'destory /users/:id' do
    it 'deletes the user' do
      expect { delete "/users/#{user_id}" }.to change { User.count }.from(10).to(9)
    end
  end
end
