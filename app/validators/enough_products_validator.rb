class EnoughProductsValidator < ActiveModel::Validator
  def validate(record)
    record.placements.each do |placement|
      product = placement.product
      if placement.quantity > product.quantity
        record.errors.add product.title, "There are not enought products, just #{product.quantity} left."
      end
    end
  end
end
