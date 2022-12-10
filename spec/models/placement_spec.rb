require 'rails_helper'

RSpec.describe Placement do
  it { is_expected.to validate_presence_of(:order_id) }
  it { is_expected.to validate_presence_of(:product_id) }

  it { is_expected.to belong_to(:order) }
  it { is_expected.to belong_to(:product).inverse_of(:placements) }
end
