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
end
