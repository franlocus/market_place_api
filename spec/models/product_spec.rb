require 'rails_helper'

RSpec.describe Product do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  it { is_expected.to belong_to(:user) }

  describe 'search' do
    before do
      1.upto(3) { |n| create(:product, title: 'Expensive A TV', price: n * 200) }
    end

    context 'when filtering by title' do
      it 'returns products filtered by title' do
        expect(described_class.filter_by_title('tv').count).to eq(3)
      end

      it 'returns products filtered by title and sorted' do
        create(:product, title: 'Z TV Cheaper')
        filtered_and_sorted_tvs = described_class.filter_by_title('tv').sort

        expect(filtered_and_sorted_tvs.first.title).to match(/A TV/)
        expect(filtered_and_sorted_tvs.last.title).to match(/Z TV/)
      end
    end

    context 'when filtering by price' do
      it { expect(described_class.above_or_equal_to_price(300).count).to eq(2)  }
      it { expect(described_class.below_or_equal_to_price(300).order(:price).last.price).to eq(200)  }
    end

    context 'when filtering by creation date' do
      it do
        create(:product, title: 'Black Friday Box') # This will be the most recent

        expect(described_class.recent.last.title).to match(/Box/)
      end
    end
  end
end
