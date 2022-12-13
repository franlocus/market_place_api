require 'rails_helper'

RSpec.describe Placement do
  let!(:placement) { create(:placement) }

  it { is_expected.to belong_to(:order) }
  it { is_expected.to belong_to(:product).inverse_of(:placements) }

  context 'when creating a placement' do
    it 'decreases the product quantity by the placement quantity' do
      product = placement.product
      expect { placement.decrement_product_quantity! }.to change(product, :quantity).by(-placement.quantity)
    end
  end
end
