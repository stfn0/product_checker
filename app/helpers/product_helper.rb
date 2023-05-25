module ProductHelper

  require 'json' #gem to work with JSON
  require 'digest' #gem to work with md5 hash
  require 'net/http'
  require 'uri'
  
  #Remove all the requested fields from the json
  def remove_fields(product, fields) 
    case product
    when Array  
      product.each { |item| remove_fields(item, fields)}
    when Hash
      product.delete_if { |k,v| fields.include?(k)}
      product.each { |k,v| remove_fields(v, fields)}
    end
    #turn it back to JSON
    product_new_json = JSON.generate(product)  
  
    #puts product_new_json
    return product_new_json
  end
    
  #Get the (STRING)json from the URL and returns the json in hash format to be sent to the remove_fields method
  def url_to_json(product_url)
    #puts(product_url)
    product_full_json = Net::HTTP.get(URI.parse(product_url)) #URI.open(product_url).read
    product_hash = JSON.parse(product_full_json)
    return product_hash
  end
  
  def json_to_md5(product_new_json) 
    #turning into md5 hash
    json_hash = JSON.parse(product_new_json).to_s
    md5_hash = Digest::MD5.hexdigest(json_hash)
  end
       
  #Add product 
  def create_product(url)
    #turn the url json into a ruby hash
    product_hash = url_to_json(url)
    updated_at = product_hash["product"]["updated_at"]
    prices = product_hash["product"]["variants"][0]["price"]
    image_path = product_hash["product"]["image"]["src"]
    title = product_hash["product"]["title"]
    #remove the fields and returns a JSON(not a hash)
    product_json_rem_fields = remove_fields(product_hash, ["updated_at"])
   
    Product.new(
      url: url, 
      hash_md5: json_to_md5(product_json_rem_fields),
      product_updated_at: updated_at,
      sales: 0, 
      price: prices,
      image_path: image_path,
      title: title,
    )
  end
end