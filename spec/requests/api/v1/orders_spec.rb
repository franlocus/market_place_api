require 'rails_helper'

RSpec.describe 'Api::V1::Orders' do
  let!(:order) { create(:order) }

  describe "GET /index" do
    context 'with authorization' do
      it 'returns status ok with user orders' do
        get api_v1_orders_path, headers: { Authorization: JsonWebToken.encode(user_id: order.user_id) }
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['data'].count).to eq(order.user.orders.count)
      end
    end

    context 'without authorization' do
      before { get api_v1_orders_path }

      it { expect(response).to have_http_status(:forbidden) }
    end
  end
end
