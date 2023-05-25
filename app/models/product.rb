class Product
  include Mongoid::Document

  field :url, type: String
  field :hash_md5, type: String
  field :product_updated_at, type: String
  field :sales, type: Integer
  field :price, type: String
  field :image_path, type: String
  field :title, type: String

  belongs_to :user

end