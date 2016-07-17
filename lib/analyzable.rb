module Analyzable
  # Your code goes here!
  def average_price(products)
    total_price = 0
    products.each do |product|
      total_price = total_price + product.price.to_f
    end
    (total_price/products.length).round(2)
  end

  def count_by_brand(products)
    hash = {}
    products.each do |product|
      if(hash.has_key?(product.brand))
        hash[product.brand] += 1
      else
        hash.store(product.brand,1)
      end
    end
    return hash
  end


  def count_by_name(products)
    hash = {}
    products.each do |product|
      if(hash.has_key?(product.name))
        hash[product.name] += 1
      else
        hash.store(product.name,1)
      end
    end
    return hash
  end


  def print_report(products)
    avg_price = average_price(products)
    puts "Inventory by Brand"
    hash = count_by_brand(products)
    hash.each do |brand,count|
      puts "- #{brand}: #{count}".rjust(4)
    end
    puts "Inventory by Name"
    hash = count_by_name(products)
    hash.each do |brand,count|
      puts "- #{brand}: #{count}".rjust(4)
    end
    return "Average price: #{avg_price}"
  end

end
