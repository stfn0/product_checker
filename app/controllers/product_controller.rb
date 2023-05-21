class ProductController < ApplicationController
  include ProductHelper
  
  
  # def index
  # end

  # def show
  # end

  # def new
  # end

  def create
    product = create_product(params[:url])
    product.save()
  end

  # def edit
  # end

  # def update
  # end

  # def destroy
  # end
end
