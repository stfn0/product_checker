class UpdateProductWorker
  include Sidekiq::Worker
  include ProductHelper

  def perform(id)
    # Task logic goes here
    # Access MongoDB using the appropriate model and perform operations
    # Add update method and keep it in a loop
    # Puxar cada URL do banco e rodar um loop passando nos ifs e fazneod update no banco. 
    
    # Pegar 1 URL de cada do banco
    # unique_urls = Product.distinct(:url)
    # Pegar 1 produto que tem uma dessas URL
    # products = unique_urls.map do |url|
    # Product.where(url: url).first
    # end.compact
    # Uso os dados produto obtido e os dados do link pra trabalhar no algoritmo
    #
    # Rodo um update em todos os produtos que compartilham da mesma URL
    # UpdateDB: Product.where(url: url).set(product_updated_at: new_updated_at, hash_md5: new_hash_md5, sales: new_sales)

        

    update_happened = true
    productDB = Product.find(id)
    
    puts "--!!!--#{productDB.product_updated_at}--!!!!---"
    puts "--!!!--#{productDB.hash_md5}--!!!!---"  

    updated_product = create_product(productDB.url.to_s) 

    if ((productDB[:product_updated_at] == updated_product[:product_updated_at]) && (productDB[:hash_md5] == updated_product[:hash_md5]))
       puts "mudou nada"
       update_happened = false
    end
    
    if ((productDB[:product_updated_at] != updated_product[:product_updated_at]) && (productDB[:hash_md5] == updated_product[:hash_md5]))      
      updated_product[:sales] = productDB[:sales];
      updated_product[:sales] += 1  
      puts "----- Vendeu!!! #{productDB.title}---------------"    
    end

    if(update_happened)
      puts "----------------------- productDB vs updated_product ---------------------"
      puts "---#{productDB.product_updated_at} vs #{updated_product.product_updated_at} ---------------- "
      puts "---#{productDB.hash_md5} vs #{updated_product.hash_md5} --"
      puts "--------------------------------------------------------------------------"
      #productDB = updated_product;
      #productDB.update_attributes(updated_product.attributes)
      obj_write_result = productDB.update(
        url: updated_product[:url],
        hash_md5: updated_product[:hash_md5],
        product_updated_at: updated_product[:product_updated_at],       
        sales: updated_product[:sales], 
        price: updated_product[:price],
        image_path: updated_product[:image_path],
        title: updated_product[:title], 
      )

      puts "--Update: #{productDB.title}---------------"
      puts "--Update: #{obj_write_result}---------------"

     end
    
    self.class.perform_in(10.seconds, id)    
  end
end