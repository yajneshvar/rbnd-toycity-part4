require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  #attr_reader :data_path
  @data_path = File.dirname(__FILE__) + "/../data/data.csv"

  def self.create(opts)
    product = Product.new(opts)
    CSV.open(self.data_path, "ab") do |csv|
      csv << [product.id,product.brand,product.name,product.price]
    end
    product
  end

  def self.all
    product = []
    CSV.foreach(Udacidata.data_path,{headers: true, return_headers: false}) do |row|
      new_product = Product.new({id:row[0],brand:row[1],name:row[2],price:row[3]})
      product << new_product
    end
    return product
  end

  def self.first(count=1)
    faster_csv = read_csv
    info = faster_csv.first(count)
    if(count == 1)
      prod = Product.new({id: info[0][0],brand: info[0][1], name: info[0][2], price: info[0][3] })
      return prod
    else
      product = []
      info.each do |attr|
        product << Product.new({id: attr[0],brand: attr[1], name: attr[2], price: attr[3] })
      end
      return product
    end
  end


  def self.last(count=1)
    faster_csv = read_csv
    info = faster_csv.reverse_each.first(count)
    if(count == 1)
      prod = Product.new({id: info[0][0],brand: info[0][1], name: info[0][2], price: info[0][3] })
      return prod
    else
      product = []
      info.each do |attr|
        product << Product.new({id: attr[0],brand: attr[1], name: attr[2], price: attr[3] })
      end
      return product
    end
  end

  def self.find(id)
    faster_csv = read_csv
    prod = faster_csv.find do |product|
                        product.fetch("id") == id
                      end
    if(prod.nil?)
      raise ProductNotFoundError, "Product with id #{id} not found"
    end
    product = Product.new({id: prod.fetch("id"),brand: prod.fetch("brand"), name: prod.fetch("product"), price: prod.fetch("price")})
  end

  def self.destroy(id)
    faster_csv = read_csv
    table = CSV::Table.new(faster_csv)
    deleted_prod = nil
    table.delete_if do |product|
      if(product.fetch("id") == id)
        deleted_prod = Product.new({id: product.fetch("id"),brand: product.fetch("brand"), name: product.fetch("product"), price: product.fetch("price")})
      end
    end
    if(deleted_prod.nil?)
      raise ProductNotFoundError, "Product with id #{id} not found"
    end
    File.open(Udacidata.data_path,'w') do |file|
      file.write(faster_csv.to_csv)
    end
    return deleted_prod
  end


  def self.where(opts={})
    faster_csv = read_csv
    prod = faster_csv.select do |product|
                        product.fetch("brand") == opts[:brand] || product.fetch("product") == opts[:name]
                      end
    product = []
    prod.each do |prod_info|
      product << Product.new({id: prod_info.fetch("id"),brand: prod_info.fetch("brand"), name: prod_info.fetch("product"), price: prod_info.fetch("price")})
    end
    return product
  end

  def update(opts={})
    deleted_prod = self.class.destroy(id)
    old_data = {id: id, brand: deleted_prod.brand, name: deleted_prod.name, price: deleted_prod.price}
    updated_data = old_data.merge(opts)
    self.class.create(updated_data)
  end

  def self.read_csv
    CSV.read(Udacidata.data_path,{headers: true, return_headers: false, converters: :numeric})
  end

  def self.data_path
    File.dirname(__FILE__) + "/../data/data.csv"
  end

end
