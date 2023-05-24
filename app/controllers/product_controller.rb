class ProductController < ApplicationController
  include ProductHelper
  
  
  def create_
    product = create_product(params[:url])
    product.save()
  end

end
