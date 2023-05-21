module ProductHelper

  require 'json' #gem to work with JSON
  require 'digest' #gem to work with md5 hash
  #require 'open-uri' #gem to read the content from an url
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
    puts(product_url)
    product_full_json = Net::HTTP.get(URI.parse(product_url)) #URI.open(product_url).read
    product_hash = JSON.parse(product_full_json)
    return product_hash
  end
  
  def json_to_md5(product_new_json) 
    #turning into md5 hash
  json_hash = JSON.parse(product_new_json).to_s
  md5_hash = Digest::MD5.hexdigest(json_hash)
  end
  
  
  #######################################################
  
  #Preciso guardar em um objeto(hash em rubi) as infos de um product
  
  # product = {id: "", url: "", hash_md5: "", updated_at: "", sales: "", price: ""}
  
  # Popular o product com as informações
  
  # product[:id]
  # product[:url] = "https://www.puravidabracelets.com/products/carbon-offset-for-shipping.json"
  # product[:hash_md5] = "0"
  # product[:updated_at] = "0"
  # product[:sales] = ""
  # product[:price] = ""
     
  #Add product 
  def create_product(url)
    #turn the url json into a ruby hash
    product_hash = url_to_json(url)
    updated_at = product_hash["product"]["updated_at"]
    prices = product_hash["product"]["variants"][0]["price"]
    #remove the fields and returns a JSON(not a hash)
    product_json_rem_fields = remove_fields(product_hash, ["updated_at"])
   
    Product.new(
      url: url,    
      hash_md5: json_to_md5(product_json_rem_fields),
      product_updated_at: updated_at,
      sales: 0, 
      price: prices
    )    
  end
    
  # def update_product(db_product, url )
  #   url_product = create_product(url);
    
  #   # if ((db_product[:updated_at] == url_product[:updated_at]) && (db_product[:hash_md5] == url_product[:hash_md5])) {
  #   #   return
  #   # }  
  
  #   if ((db_product[:updated_at] != url_product[:updated_at]) && (db_product[:hash_md5] == url_product[:hash_md5])) {      
  #     url_product[:sales] = db_product[:sales];
  #     url_product[:sales] += 1
  #   } 
  
  #   db_product = url_product;
  #   db_product.update()
  # end
  
  

end
