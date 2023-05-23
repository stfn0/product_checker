# app/controllers/dashboard_controller.rb
require 'uri'

class DashboardController < ApplicationController
  # ...
  include ProductHelper  
  # def process_url(url)
  #   puts "###################################"
  #   puts url
  #   puts "###################################"
  #   product = create_product(url)
  # end

  def add_product

    url = params[:url]
    has_product = Current.user.products.where(url: params[:url]).first
    
    if (has_product.nil?)
      if (is_json_url?(url))
        product = create_product(url)      
        Current.user.products << product 

        redirect_to dashboard_path, notice: "Product added successfully."
      else
        return wrong_url()
      end
    else
      redirect_to dashboard_path, alert: "You already have the URL added."
    end
  end 
  

  def wrong_url()
    redirect_to dashboard_path, alert: "Invalid product URL."
  end
end


def is_json_url?(url)
  uri = URI.parse(url)
  return false unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  
  # Check if the path or extension corresponds to JSON format
  return true if uri.path.end_with?('.json') || File.extname(uri.path) == '.json'
  false
end