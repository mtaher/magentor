module Magento
  # http://www.magentocommerce.com/wiki/doc/webservices-api/api/catalog_product_type
  class ProductType < Base
    class << self
      # catalog_product_type.list
      # Retrieve product types
      # 
      # Return: array
      def list(connection)
        results = commit(connection, "list", nil)
        results.collect do |result|
          new(result)
        end
      end
    end
  end
end