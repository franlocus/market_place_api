FactoryBot.define do
  factory :order do
    total { '1.99' }
    user
  end
end
