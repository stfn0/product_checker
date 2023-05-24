class ProductsController < ApplicationController

  def create
    @product = Current.user.products.build(product_params)
    if @product.save
      redirect_to root_path, notice: "Product added successfully."
    else
      render :new
    end
  end

  private

  def product_params
    params.require(:product).permit(:url, :hash_md5, :product_updated_at, :sales, :price, :image_path, :title)
  end
end