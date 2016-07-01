require_relative 'udacidata'

class Product < Udacidata
  attr_reader :id, :price, :brand, :name

  def initialize(opts={})
    # Get last ID from the database if ID exists
    get_last_id
    # Set the ID if it was passed in, otherwise use last existing ID
    @id = opts[:id] ? opts[:id].to_i : @@count_class_instances
    # Increment ID by 1
    auto_increment if !opts[:id]
    # Set the brand, name, and price normally
    @brand = opts[:brand]
    @name = opts[:name]
    @price = opts[:price]
  end

  def self.all
    product = []
    CSV.foreach(Udacidata.data_path,{headers: true, return_headers: false}) do |row|
      new_product = Product.new({id:row[0],brand:row[1],product:row[2],price:row[3]})
      product << new_product
    end
    return product
  end

  def self.first(count=1)
    faster_csv = read_csv
    info = faster_csv.first(count)
    if(count == 1)
      prod = Product.new({id: info[0][0],brand: info[0][1], product: info[0][2], price: info[0][3] })
      return prod
    else
      product = []
      info.each do |attr|
        product << Product.new({id: attr[0],brand: attr[1], product: attr[2], price: attr[3] })
      end
      return product
    end
  end

  def self.last(count=1)
    faster_csv = read_csv
    info = faster_csv.reverse_each.first(count)
    if(count == 1)
      prod = Product.new({id: info[0][0],brand: info[0][1], product: info[0][2], price: info[0][3] })
      return prod
    else
      product = []
      info.each do |attr|
        product << Product.new({id: attr[0],brand: attr[1], product: attr[2], price: attr[3] })
      end
      return product
    end
  end

  def self.find(id)
    faster_csv = read_csv
    prod = faster_csv.find do |product|
                        product.fetch("id") == id
                      end
    product = Product.new({id: prod.fetch("id"),brand: prod.fetch("brand"), product: prod.fetch("product"), price: prod.fetch("product")})
    #build the product
  end

  def self.read_csv
    CSV.open(Udacidata.data_path,{headers: true, return_headers: false, converters: :numeric})
  end

  private

    # Reads the last line of the data file, and gets the id if one exists
    # If it exists, increment and use this value
    # Otherwise, use 0 as starting ID number
    def get_last_id
      file = File.dirname(__FILE__) + "/../data/data.csv"
      last_id = File.exist?(file) ? CSV.read(file).last[0].to_i + 1 : nil
      @@count_class_instances = last_id || 0
    end

    def auto_increment
      @@count_class_instances += 1
    end


end
