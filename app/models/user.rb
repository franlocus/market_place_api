class User < ApplicationRecord
  has_secure_password

  validates :email, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, message: 'is invalid format' }
  validates :password_digest, presence: true
end
