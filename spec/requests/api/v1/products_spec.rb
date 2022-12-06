require 'rails_helper'

RSpec.describe 'Api::V1::Products' do
  describe 'GET /index' do
    before { get api_v1_products_path }

    it { expect(response).to have_http_status(:ok) }

    it 'returns indexed products' do
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(Product.count)
    end
  end

  describe 'GET /show' do
    let!(:product) { create(:product) }

    before { get api_v1_product_path(product) }

    it { expect(response).to have_http_status(:ok) }

    it 'returns show product' do
      json_response = JSON.parse(response.body)
      expect(json_response['title']).to eq(product.title)
    end
  end
end
