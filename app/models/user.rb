
class User
  include Mongoid::Document
  include ActiveModel::SecurePassword
  
  has_secure_password  
  field :email
  field :password_digest

  
  validates :email, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "The email must be a valid"}, uniqueness: true
  validates :password, length: {minimum: 6}, allow_blank: true
  validates :password_confirmation, presence: true

  has_many :products
end