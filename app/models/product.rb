class Product < ApplicationRecord
  validates :title, presence: true
  validates :user_id, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, presence: true

  belongs_to :user
  has_many :placements, dependent: :destroy
  has_many :orders, through: :placements

  scope :keyword, ->(keyword) { where('lower(title) LIKE ?', "%#{keyword.downcase}%") }
  scope :min_price, ->(price) { where('price >= ?', price) }
  scope :max_price, ->(price) { where('price <= ?', price) }
  scope :recent, -> { order(:updated_at) }

  def self.search(params = {})
    products = params[:product_ids].present? ? Product.where(id: params[:product_ids]) : Product.all

    allowed_params = %i[keyword min_price max_price recent]

    params.each do |param, value|
      next unless allowed_params.include?(param.to_sym)

      products = products.send(param, value)
    end

    products
  end
end
