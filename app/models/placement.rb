class Placement < ApplicationRecord
  validates :order_id, presence: true
  validates :product_id, presence: true

  belongs_to :order
  belongs_to :product, inverse_of: :placements
end
