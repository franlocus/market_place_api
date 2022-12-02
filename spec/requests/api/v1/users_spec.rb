require 'rails_helper'

RSpec.describe 'Api::V1::Users' do
  let!(:user) { create(:user) }

  describe 'GET /users#show' do
    before { get api_v1_user_path(user) }

    it { expect(response).to have_http_status(:ok) }

    it 'show user' do
      json_response = JSON.parse(response.body)
      expect(json_response['email']).to eq(user.email)
    end
  end

  describe 'POST /users#create' do
    before do
      post api_v1_users_path, params: { user: { email: 'buddy@test.org', password: '123456' } }
    end

    it { expect(response).to have_http_status(:created) }

    it 'creates a user' do
      json_response = JSON.parse(response.body)
      expect(json_response['email']).to eq('buddy@test.org')
    end

    it 'doesnt create a user with taken email' do
      post api_v1_users_path, params: { user: { email: 'buddy@test.org', password: '123456' } }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH /users#update' do
    before do
      patch api_v1_user_path(user), params: { user: { email: 'happy-buddy@test.org', password: '123456' } }
    end

    it { expect(response).to have_http_status(:success) }

    it 'updates a user' do
      json_response = JSON.parse(response.body)
      expect(json_response['email']).to eq('happy-buddy@test.org')
    end

    it 'doesnt update a user when invalid params are sent' do
      post api_v1_users_path, params: { user: { email: 'bad_email', password: '123456' } }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
