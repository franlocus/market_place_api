class Api::V1::ProductsController < ApplicationController
  before_action :set_product, only: %i[show]

  def index
    render json: Product.all
  end

  def show
    render json: @product
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
end
