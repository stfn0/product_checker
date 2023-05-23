class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @product = @user.products.build
  end
end
