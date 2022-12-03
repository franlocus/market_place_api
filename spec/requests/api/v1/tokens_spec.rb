require 'rails_helper'

RSpec.describe 'Api::V1::Tokens' do
  let!(:user) { create(:user) }

  describe 'POST /tokens#create' do
    it 'returns JWT token' do
      post api_v1_tokens_path, params: { user: { email: user.email, password: 'g00d_pa$$' } }
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response['token']).not_to be_nil
    end

    it 'doesnt return JWT token' do
      post api_v1_tokens_path, params: { user: { email: user.email, password: 'b@d_pa$$' } }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
