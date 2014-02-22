module Magento
  # http://www.magentocommerce.com/wiki/doc/webservices-api/api/customer
  # 100  Invalid customer data. Details in error message.
  # 101  Invalid filters specified. Details in error message.
  # 102  Customer does not exist.
  # 103  Customer not deleted. Details in error message.
  class Customer < Base
    class << self
      # customer.list
      # Retrieve customers
      # 
      # Return: array
      # 
      # Arguments:
      # 
      # array filters - filters by customer attributes (optional)
      # filter list - “updated_at”, “website_id”, “increment_id”, “lastname”, “group_id”, 
      #   “firstname”, “created_in”, “customer_id”, “password_hash”, “store_id”, “email”, “created_at”
      # 
      # Note: password_hash will only match exactly with the same MD5 and salt as was used when 
      # Magento stored the value. If you try to match with an unsalted MD5 hash, or any salt other 
      # than what Magento used, it will not match. This is just a straight string comparison.
      def list(connection, *args)
        results = commit(connection, "list", *args)
        results.collect do |result|
          new(result)
        end
      end

      # customer.create
      # Create customer
      # 
      # Return: int
      # 
      # Arguments:
      # 
      # array customerData - cutomer data (email, firstname, lastname, etc...)
      def create(connection, attributes)
        id = commit(connection, "create", attributes)
        record = new(attributes)
        record.id = id
        record
      end
    
    
      # customer.info
      # Retrieve customer data
      # 
      # Return: array
      # 
      # Arguments:
      # 
      # int customerId - Customer ID.
      # array attributes | string attribute (optional depending on version) - 
      #   return only these attributes. Possible attributes are updated_at, increment_id, 
      #   customer_id, created_at. The value, customer_id, is always returned.
      def info(connection, *args)
        new(commit(connection, "info", *args))
      end
    
      # customer.update
      # Update customer data
      # 
      # Return: boolean
      # 
      # Arguments:
      # 
      # int customerId - customer ID
      # array customerData - customer data (email, firstname, etc...)
      def update(connection, *args)
        commit(connection, "update", *args)
      end
    
    
      # customer.delete
      # Delete customer
      # 
      # Return: boolean
      # 
      # Arguments:
      # 
      # int customerId - customer ID.
      def delete(connection, *args)
        commit(connection, "delete", *args)
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
    
    def addresses(connection)
      Magento::CustomerAddress.list(connection, self.id)
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