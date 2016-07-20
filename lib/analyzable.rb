module Analyzable
  # Your code goes here!
  def average_price(products)
    (products.inject(0) {|sum, product| sum + product.price.to_f}/products.size).round(2)
  end

  [:brand, :name].each do |field|
      send(:define_method, "count_by_#{field}") do |products|
        sums = Hash.new(0)
        products.each do |product|
          value = product.send(field)
          sums[value] += 1
        end
        sums
      end
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
