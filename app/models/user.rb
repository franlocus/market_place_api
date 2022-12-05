class User < ApplicationRecord
  has_secure_password
  has_many :products, dependent: :destroy

  validates :email, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, message: 'is invalid format' }
  validates :password_digest, presence: true
end
