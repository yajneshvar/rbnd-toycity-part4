require 'faker'

# This file contains code that populates the database with
# fake data for testing purposes

def db_seed
  @data_path = File.dirname(__FILE__) + "/../data/data.csv"
  CSV.open(@data_path, "ab") do |csv|
    10.times do
      csv << [Faker::Number.digit, Faker::Commerce.department, Faker::Commerce.product_name, Faker::Commerce.price]
    end
  end
end
