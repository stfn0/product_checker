
class User
  include Mongoid::Document
  include ActiveModel::SecurePassword
  
  has_secure_password  
  field :email
  field :password_digest

  
  validates :email, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "The email must be a valid"}
  validates :password, presence: true, length: { minimum: 6 }
  
  has_many :products
end