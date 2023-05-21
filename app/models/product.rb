class Product
  include Mongoid::Document

  field :url, type: String
  field :string, type: String
  field :hash_md5, type: String
  field :string, type: String
  field :product_updated_at, type: String
  field :string, type: String
  field :sales, type: String
  field :integer, type: String
  field :price, type: String
  field :string, type: String

  validates :url, uniqueness: true

  belongs_to :user, class_name: "::Models::User", inverse_of: :product

end