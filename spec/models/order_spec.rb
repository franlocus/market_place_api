require 'rails_helper'

RSpec.describe Order do
  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:placements).dependent(:destroy) }
  it { is_expected.to have_many(:products).through(:placements) }

  context 'when creating an order' do
    it 'sets its total' do
      products = [create(:product, price: rand(0.0..1000)), create(:product, price: rand(0.0..1000))]

      order = described_class.new(user_id: create(:user).id)
      order.products << products
      order.save
      expect(products.sum(&:price)).to eq(order.total)
    end
  end

  context 'when managing quantities' do
    let!(:order) { create(:order) }

    it 'builds 2 placements for the order' do
      products = [create(:product), create(:product)]

      order.build_placements_with_product_ids_and_quantities [{ product_id: products.first.id, quantity: 2 },
                                                              { product_id: products.last.id, quantity: 3 }]
      expect { order.save }.to change(Placement, :count)
    end

    it 'checks order doesnt contain more products than available' do
      product = create(:product)
      order.placements << Placement.new(product_id: product.id, quantity: (1 + product.quantity))

      expect(order).not_to be_valid
    end
  end
end
