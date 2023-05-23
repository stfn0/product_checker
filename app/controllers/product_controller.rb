class ProductController < ApplicationController
  include ProductHelper
  
  
  def create_
    puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    product = create_product(params[:url])
    product.save()
  end

end
