FactoryBot.define do
  factory :product do
    title { 'Notebook' }
    price { '99.99' }
    published { false }
    quantity { 5 }
    user
  end
end
