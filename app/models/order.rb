class Order < ApplicationRecord
  before_validation :set_total!

  validates :user_id, presence: true

  belongs_to :user
  has_many :placements, dependent: :destroy
  has_many :products, through: :placements

  private

  def set_total!
    self.total = products.sum(&:price)
  end
end
