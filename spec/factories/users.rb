FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "example-#{n}@email.com" }
    password_digest { BCrypt::Password.create('g00d_pa$$') }

    after :create do |user|
      create_list(:product, 3, user:)   # has_many
    end
  end
end
