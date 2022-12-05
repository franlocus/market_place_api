FactoryBot.define do
  factory :product do
    title { 'Notebook' }
    price { '99.99' }
    published { false }
    user
  end
end
