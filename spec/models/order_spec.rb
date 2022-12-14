require 'rails_helper'

RSpec.describe Order do
  let!(:order) { create(:order) }
  let!(:products) { [create(:product, price: rand(0.0..1000)), create(:product, price: rand(0.0..1000))] }

  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:placements).dependent(:destroy) }
  it { is_expected.to have_many(:products).through(:placements) }

  context 'when creating an order' do
    it 'sets its total' do
      order.placements = [Placement.new(product_id: products.first.id, quantity: 2),
                          Placement.new(product_id: products.last.id, quantity: 2)]
      order.set_total!
      expected_total = (products.first.price * 2) + (products.last.price * 2)
      expect(order.total).to eq(expected_total)
    end
  end

  context 'when managing quantities' do
    it 'builds placements for the order' do
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
