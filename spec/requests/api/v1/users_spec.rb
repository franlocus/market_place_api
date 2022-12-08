require 'rails_helper'

RSpec.describe 'Api::V1::Users' do
  let!(:user) { create(:user) }

  describe 'GET /users#show' do
    before { get api_v1_user_path(user) }

    it { expect(response).to have_http_status(:ok) }

    it 'show user' do
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(json_response.dig(:data, :attributes, :email)).to eq(user.email)
      expect(json_response.dig(:data, :relationships, :products, :data, 0, :id)).to eq(user.products.first.id.to_s)
      expect(json_response.dig(:included, 0, :attributes, :title)).to eq(user.products.first.title)
    end
  end

  describe 'POST /users#create' do
    before do
      post api_v1_users_path, params: { user: { email: 'buddy@test.org', password: '123456' } }
    end

    it { expect(response).to have_http_status(:created) }

    it 'creates a user' do
      json_response = JSON.parse(response.body)
      expect(json_response['data']['attributes']['email']).to eq('buddy@test.org')
    end

    it 'doesnt create a user with taken email' do
      post api_v1_users_path, params: { user: { email: 'buddy@test.org', password: '123456' } }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH /users#update' do
    context 'with authorization' do
      before do
        patch api_v1_user_path(user),
              params: { user: { email: 'happy-buddy@test.org', password: '123456' } },
              headers: { Authorization: JsonWebToken.encode(user_id: user.id) }
      end

      it { expect(response).to have_http_status(:success) }

      it 'updates a user' do
        json_response = JSON.parse(response.body)
        expect(json_response['data']['attributes']['email']).to eq('happy-buddy@test.org')
      end

      it 'doesnt update a user when invalid params are sent' do
        patch api_v1_user_path(user),
              params: { user: { email: 'bad_email', password: '123456' } },
              headers: { Authorization: JsonWebToken.encode(user_id: user.id) }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'without authorization' do
      before do
        patch api_v1_user_path(user), params: { user: { email: 'happy-buddy@test.org', password: '123456' } }
      end

      it { expect(response).to have_http_status(:forbidden) }
    end
  end

  describe 'DELETE /users#destroy' do
    context 'with authorization' do
      before { delete api_v1_user_path(user), headers: { Authorization: JsonWebToken.encode(user_id: user.id) } }

      it { expect(response).to have_http_status(:no_content) }

      it 'deleted the user' do
        expect { user.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'without authorization' do
      before { delete api_v1_user_path(user) }

      it { expect(response).to have_http_status(:forbidden) }
    end
  end
end
