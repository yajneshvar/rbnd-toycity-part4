class Module
  def create_finder_methods(*attributes)
    # Your code goes here!
    # Hint: Remember attr_reader and class_eval
    attributes.each do |attr|
      method = %Q{
        def find_by_#{attr}(val)
          faster_csv = Product.read_csv
          prod = faster_csv.find do |product|
                    field = "#{attr}" == "name" ? "product" : "#{attr}" #hack since mismatch schema and function naming
                    product.fetch(field) == val
                  end
          product = Product.new({id: prod.fetch("id"),brand: prod.fetch("brand"), name: prod.fetch("product"), price: prod.fetch("price")})
        end
      }
      Product.instance_eval(method)
    end
  end
end
