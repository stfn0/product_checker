# app/controllers/dashboard_controller.rb
require 'uri'
require 'net/http'

class DashboardController < ApplicationController
  include ProductHelper 
  before_action :require_user_logged_in

  def add_product
    url = params[:url]

    #has_product pra não adicionar o msm URL caso já exista
    has_product = Current.user.products.where(url: params[:url]).first

    if !(has_product.nil?)
      redirect_to dashboard_path, alert: "You already have the URL added." 
      return     
    end

    if !(is_valid_url(url))
      redirect_to dashboard_path, alert: "Invalid product URL."
      return
    end
               
    response = get_url_data(url)

    if(response && is_response_valid(response))
      product = create_product(url)      
      Current.user.products << product 
      redirect_to dashboard_path, notice: "Product added successfully." 
      UpdateProductWorker.perform_async(product.id.to_s)
    else
      redirect_to dashboard_path, alert: "Couldn't add the product, check your URL."
    end       
  end 
  
  def is_response_valid(response)                
    return response.is_a?(Net::HTTPSuccess) && response.content_type == 'application/json'     
  end
  
  def is_valid_url(url)    
    return url =~ /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix
  end

  def get_url_data(url)
    begin    
      uri = URI.parse(url)  
      return Net::HTTP.get_response(uri)       
    rescue URI::InvalidURIError, SocketError, Errno::ECONNREFUSED
      return nil  # Handle invalid or unreachable URLs by returning false
    end
  end
end