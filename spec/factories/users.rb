FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "example-#{n}@email.com" }
    password_digest { BCrypt::Password.create('g00d_pa$$') }
  end
end
