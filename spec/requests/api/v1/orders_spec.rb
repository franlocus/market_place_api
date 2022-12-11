require 'rails_helper'

RSpec.describe 'Api::V1::Orders' do
  let!(:order) { create(:order) }
  let!(:placement) { create(:placement) }

  describe 'GET /index' do
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

  describe 'GET /show' do
    context 'with authorization' do
      it 'returns status ok with order' do
        get api_v1_order_path(placement.order), headers: { Authorization: JsonWebToken.encode(user_id: placement.order.user_id) }
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        include_product_attr = json_response['included'][0]['attributes']
        expect(include_product_attr['title']).to eq(placement.product.title)
      end
    end

    context 'without authorization' do
      before { get api_v1_order_path(order) }

      it { expect(response).to have_http_status(:forbidden) }
    end
  end

  describe 'POST /create' do
    let!(:order_params) { { order: { product_ids: [create(:product).id, create(:product).id] } } }

    context 'with authorization' do
      it 'creates an order with two products' do
        post  api_v1_orders_path,
              headers: { Authorization: JsonWebToken.encode(user_id: order.user.id) },
              params: order_params

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq('199.98')
      end
    end

    context 'without authorization' do
      before { post api_v1_orders_path, params: order_params }

      it { expect(response).to have_http_status(:forbidden) }
    end
  end
end
