require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  #attr_reader :data_path
  @data_path = File.dirname(__FILE__) + "/../data/data.csv"

  def self.create(opts)
    product = Product.new(opts)
    CSV.open(self.data_path, "ab") do |csv|
      csv << [opts[:id],opts[:brand],opts[:name],opts[:price]]
    end
    product
  end

  def self.data_path
    File.dirname(__FILE__) + "/../data/data.csv"
  end

end
