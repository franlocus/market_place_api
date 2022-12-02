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
end