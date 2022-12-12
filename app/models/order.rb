class Order < ApplicationRecord
  before_validation :set_total!

  validates :user_id, presence: true

  belongs_to :user
  has_many :placements, dependent: :destroy
  has_many :products, through: :placements

  def build_placements_with_product_ids_and_quantities(product_ids_and_quantities)
    product_ids_and_quantities.each do |product_id_and_quantity|
      placement = placements.build(product_id: product_id_and_quantity[:product_id])
      yield placement if block_given?
    end
  end

  private

  def set_total!
    self.total = products.sum(&:price)
  end
end
