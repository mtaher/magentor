module Magento
  # http://www.magentocommerce.com/wiki/doc/webservices-api/api/catalog_product_attribute_set
  class ProductAttributeSet < Base
    class << self
      # catalog_product_attribute_set.list
      # Retrieve product attribute sets
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