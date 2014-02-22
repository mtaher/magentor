module Magento
  # http://www.magentocommerce.com/wiki/doc/webservices-api/api/catalog_product
  # 100  Requested store view not found.
  # 101  Product not exists.
  # 102  Invalid data given. Details in error message.
  # 103  Product not deleted. Details in error message.
  class Product < Base  
    class << self
      # catalog_product.list
      # Retrieve products list by filters
      # 
      # Return: array
      # 
      # Arguments:
      # 
      # array filters - array of filters by attributes (optional)
      # mixed storeView - store view ID or code (optional)
      def list(connection, *args)
        results = commit(connection, "list", *args)
        results.collect do |result|
          new(result)
        end
      end

      # catalog_product.create
      # Create new product and return product id
      # 
      # Return: int
      # 
      # Arguments:
      # 
      # string type - product type
      # int set - product attribute set ID
      # string sku - product SKU
      # array productData - array of attributes values
      def create(connection, *args)
        id = commit(connection, "create", *args)
        record = info(connection, id)
        record
      end

      # catalog_product.info
      # Retrieve product
      # 
      # Return: array
      # 
      # Arguments:
      # 
      # mixed product - product ID or Sku
      # mixed storeView - store view ID or code (optional)
      # array attributes - list of attributes that will be loaded (optional)
      def info(connection, *args)
        new(commit(connection, "info", *args))
      end

      # catalog_product.update
      # Update product
      # 
      # Return: boolean
      # 
      # Arguments:
      # 
      # mixed product - product ID or Sku
      # array productData - array of attributes values
      # mixed storeView - store view ID or code (optional)
      def update(connection, *args)
        commit(connection, "update", *args)
      end


      # catalog_product.delete
      # Delete product
      # 
      # Return: boolean
      # 
      # Arguments:
      # 
      # mixed product - product ID or Sku
      def delete(connection, *args)
        commit(connection, "delete", *args)
      end

      # catalog_product.currentStore
      # Set/Get current store view
      # 
      # Return: int
      # 
      # Arguments:
      # 
      # mixed storeView - store view ID or code (optional)
      def current_store(connection, *args)
        commit(connection, "currentStore", *args)
      end

      # catalog_product.setSpecialPrice
      # Update product special price
      # 
      # Return: boolean
      # 
      # Arguments:
      # 
      # mixed product - product ID or Sku
      # float specialPrice - special price (optional)
      # string fromDate - from date (optional)
      # string toDate - to date (optional)
      # mixed storeView - store view ID or code (optional)
      def set_special_price(connection, *args)
        commit(connection, 'setSpecialPrice', *args)
      end

      # catalog_product.getSpecialPrice
      # Get product special price data
      # 
      # Return: array
      # 
      # Arguments:
      # 
      # mixed product - product ID or Sku
      # mixed storeView - store view ID or code (optional)
      def get_special_price(connection, *args)
        commit(connection, 'getSpecialPrice', *args)
      end
      
      def find_by_id_or_sku(connection, id)
        find_by_id(connection, id)
      end
      
      def find_by_id(connection, id)
        info(connection, id)
      end

      def find(connection, find_type, options = {})
        filters = {}
        options.each_pair { |k, v| filters[k] = {:eq => v} }
        results = list(connection, filters)
        if find_type == :first
          results.first
        else
          results
        end
      end

      def all(connection)
        list(connection)
      end
      
    end
    
    def delete(connection)
      self.class.delete(connection, self.id)
    end
    
    def update_attribute(connection, name, value)
      @attributes[name] = value
      self.class.update(connection, self.id, Hash[*[name.to_sym, value]])
    end
    
    def update_attributes(connection, attrs)
      attrs.each_pair { |k, v| @attributes[k] = v }
      self.class.update(connection, self.id, attrs)
    end
  end
end