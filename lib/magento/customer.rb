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
      def list(client, *args)
        results = commit(client, "list", *args)
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
      def create(client, attributes)
        id = commit(client, "create", attributes)
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
      def info(client, *args)
        new(commit(client, "info", *args))
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
      def update(client, *args)
        commit(client, "update", *args)
      end
    
    
      # customer.delete
      # Delete customer
      # 
      # Return: boolean
      # 
      # Arguments:
      # 
      # int customerId - customer ID.
      def delete(client, *args)
        commit(client, "delete", *args)
      end
      
      def find_by_id(client, id)
        info(client, id)
      end

      def find(client, find_type, options = {})
        filters = {}
        options.each_pair { |k, v| filters[k] = {:eq => v} }
        results = list(client, filters)
        if find_type == :first
          results.first
        else
          results
        end
      end

      def all(client)
        list(client)
      end
    end
    
    def addresses(client)
      Magento::CustomerAddress.list(client, self.id)
    end
    
    def delete(client)
      self.class.delete(client, self.id)
    end
    
    def update_attribute(client, name, value)
      @attributes[name] = value
      self.class.update(client, self.id, Hash[*[name.to_sym, value]])
    end
    
    def update_attributes(client, attrs)
      attrs.each_pair { |k, v| @attributes[k] = v }
      self.class.update(client, self.id, attrs)
    end
  end
end