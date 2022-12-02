FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "example-#{n}@email.com" }
    password_digest { 'hashed_password' }
  end
end
