class UpdateProductWorker
  include Sidekiq::Worker
  include ProductHelper

  def perform(id)    
    update_happened = true
    productDB = Product.find(id)    

    updated_product = create_product(productDB.url.to_s) 

    if ((productDB[:product_updated_at] == updated_product[:product_updated_at]) && (productDB[:hash_md5] == updated_product[:hash_md5]))
       update_happened = false
    end
    
    if ((productDB[:product_updated_at] != updated_product[:product_updated_at]) && (productDB[:hash_md5] == updated_product[:hash_md5]))      
      updated_product[:sales] = productDB[:sales];
      updated_product[:sales] += 1
    end

    if(update_happened)
      Product.where(url: updated_product[:url]).update_all({
        "$set" => {
          hash_md5: updated_product[:hash_md5],
          product_updated_at: updated_product[:product_updated_at],
          price: updated_product[:price],
          image_path: updated_product[:image_path],
          title: updated_product[:title]
        },
        "$inc" => {
          sales: 1
        }      
      })
    end    
    self.class.perform_in(10.seconds, id)    
  end
end