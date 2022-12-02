require 'rails_helper'

RSpec.describe 'Api::V1::Users' do
  let!(:user) { create(:user) }

  describe 'GET /show#user' do
    before { get api_v1_user_path(user) }

    it { expect(response).to have_http_status(:ok) }

    it 'show user' do
      json_response = JSON.parse(response.body)
      expect(json_response['email']).to eq(user.email)
    end
  end
end
