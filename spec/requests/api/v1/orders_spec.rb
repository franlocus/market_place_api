require 'rails_helper'

RSpec.describe 'Api::V1::Orders' do
  let!(:order) { create(:order) }
  let!(:placement) { create(:placement) }

  describe 'GET /index' do
    context 'with authorization' do
      before do
        get api_v1_orders_path, headers: { Authorization: JsonWebToken.encode(user_id: order.user_id) }
      end

      it 'returns status ok with user orders' do
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['data'].count).to eq(order.user.orders.count)
      end

      it 'returns users orders with pagination links' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expected_pagination_symbols = %i[first last prev next]

        expect(json_response[:links].keys).to eq(expected_pagination_symbols)
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
    let!(:products) { [create(:product), create(:product)] }
    let!(:order_params) do
      { order: { product_ids_and_quantities: [{ product_id: products.first.id, quantity: 2 },
                                              { product_id: products.last.id, quantity: 3 }] } }
    end

    context 'with authorization' do
      it 'creates an order with two products' do
        expect do
          post  api_v1_orders_path,
                headers: { Authorization: JsonWebToken.encode(user_id: order.user.id) },
                params: order_params
        end.to change(Order, :count).by(1).and(change(Placement, :count).by(2))

        expect(response).to have_http_status(:created)
      end
    end

    context 'without authorization' do
      before { post api_v1_orders_path, params: order_params }

      it { expect(response).to have_http_status(:forbidden) }
    end
  end
end
