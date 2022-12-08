require 'rails_helper'

RSpec.describe 'Api::V1::Products' do
  let!(:user) { create(:user) }
  let!(:product) { create(:product, user:) }

  describe 'GET /index' do
    before { get api_v1_products_path }

    it { expect(response).to have_http_status(:ok) }

    it 'returns indexed products' do
      json_response = JSON.parse(response.body)
      expect(json_response['data'].size).to eq(Product.count)
    end
  end

  describe 'GET /show' do
    before { get api_v1_product_path(product) }

    it { expect(response).to have_http_status(:ok) }

    it 'returns show product' do
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(json_response.dig(:data, :attributes, :title)).to eq(product.title)
      expect(json_response.dig(:data, :relationships, :user, :data, :id)).to eq(product.user.id.to_s)
      expect(json_response.dig(:included, 0, :attributes, :email)).to eq(product.user.email)
    end
  end

  describe 'POST /create' do
    context 'with authorization' do
      before do
        post api_v1_products_path,
             params: { product: { title: product.title, price: product.price, published: product.published } },
             headers: { Authorization: JsonWebToken.encode(user_id: product.user_id) }
      end

      it { expect(response).to have_http_status(:created) }

      it { expect(Product.last.title).to eq(product.title) }
    end

    context 'without authorization' do
      before do
        post api_v1_products_path,
             params: { product: { title: product.title, price: product.price, published: product.published } }
      end

      it { expect(response).to have_http_status(:forbidden) }
    end
  end

  describe 'PATCH /update' do
    context 'with authorization' do
      before do
        patch api_v1_product_path(product),
              params: { product: { title: "#{product.title} new" } },
              headers: { Authorization: JsonWebToken.encode(user_id: product.user_id) }
      end

      it { expect(response).to have_http_status(:success) }

      it { expect(Product.last.title).to eq("#{product.title} new") }
    end

    context 'when signed in but without being product owner' do
      # Another user cannot modify first user's product
      before do
        patch api_v1_product_path(product),
              params: { product: { title: "#{product.title} new" } },
              headers: { Authorization: JsonWebToken.encode(user_id: create(:user).id) }
      end

      it { expect(response).to have_http_status(:forbidden) }
    end
  end

  describe 'DELETE /destroy' do
    context 'with authorization' do
      before do
        delete api_v1_product_path(product), headers: { Authorization: JsonWebToken.encode(user_id: product.user_id) }
      end

      it { expect(response).to have_http_status(:no_content) }

      it { expect { product.reload }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'when signed in but without being product owner' do
      # Another user cannot delete first user's product
      before do
        delete api_v1_product_path(product), headers: { Authorization: JsonWebToken.encode(user_id: create(:user).id) }
      end

      it { expect(response).to have_http_status(:forbidden) }
    end
  end
end
