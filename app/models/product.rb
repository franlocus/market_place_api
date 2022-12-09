class Product < ApplicationRecord
  validates :title, presence: true
  validates :user_id, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, presence: true

  belongs_to :user

  scope :filter_by_title, ->(keyword) { where('lower(title) LIKE ?', "%#{keyword.downcase}%") }
  scope :above_or_equal_to_price, ->(price) { where('price >= ?', price) }
  scope :below_or_equal_to_price, ->(price) { where('price <= ?', price) }
  scope :recent, -> { order(:updated_at) }

  def self.search(params = {})
    # TODO: refactor
    products = params[:product_ids].present? ? Product.where(id: params[:product_ids]) : Product.all

    products = products.filter_by_title(params[:keyword]) if params[:keyword].present?
    products = products.above_or_equal_to_price(params[:min_price]) if params[:min_price].present?
    products = products.below_or_equal_to_price(params[:max_price]) if params[:max_price].present?
    products = products.recent if params[:recent].present?

    products
  end
end
