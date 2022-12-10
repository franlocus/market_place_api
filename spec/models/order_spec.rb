require 'rails_helper'

RSpec.describe Order do
  it { is_expected.to validate_numericality_of(:total).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:placements).dependent(:destroy) }
  it { is_expected.to have_many(:products).through(:placements) }
end
