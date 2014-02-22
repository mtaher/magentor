module Magento
  # http://www.magentocommerce.com/wiki/doc/webservices-api/api/catalog_category_attribute
  # 100  Requested store view not found.
  # 101  Requested attribute not found.
  class CategoryAttribute < Base
    class << self
      # catalog_category_attribute.list
      # Retrieve category attributes
      # 
      # Return: array
      def list(connection)
        results = commit(connection, "list", nil)
        results.collect do |result|
          new(result)
        end
      end

      # catalog_category_attribute.currentStore
      # Set/Get current store view
      # 
      # Return: int
      # 
      # Arguments:
      # 
      # mixed storeView - Store view ID or code. (optional)
      def current_store(connection, *args)
        commit(connection, "currentStore", *args)
      end

      # catalog_category_attribute.options
      # Retrieve attribute options
      # 
      # Arguments:
      # 
      # attributeId - attribute id or code
      # storeView - store view id or code
      def options(connection, *args)
        commit(connection, "options", *args)
      end
    end
  end
end