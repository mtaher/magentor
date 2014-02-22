module Magento
  # http://www.magentocommerce.com/wiki/doc/webservices-api/api/customer_address
  # 100  Invalid address data. Details in error message.
  # 101  Customer not exists.
  # 102  Address not exists.
  # 103  Address not deleted. Details in error message.
  class CustomerAddress < Base
    class << self
       # customer_address.list
        # Retrieve customer addresses
        # 
        # Return: array
        # 
        # Arguments:
        # 
        # int customerId - Customer Id
        def list(connection, *args)
          results = commit(connection, "list", *args)
          results.collect do |result|
            new(result)
          end
        end

        # customer_address.create
        # Create customer address
        # 
        # Return: int
        # 
        # Arguments:
        # 
        # int customerId - customer ID
        # array addressData - adress data (country, zip, city, etc...)
        def create(connection, customer_id, attributes)
          id = commit(connection, "create", customer_id, attributes)
          record = new(attributes)
          record.id = id
          record
        end

        # customer_address.info
        # Retrieve customer address data
        # 
        # Return: array
        # 
        # Arguments:
        # 
        # int addressId - customer address ID
        def info(connection, *args)
          new(commit(connection, "info", *args))
        end

        # customer_address.update
        # Update customer address data
        # 
        # Return: boolean
        # 
        # Arguments:
        # 
        # int addressId - customer address ID
        # array addressData - adress data (country, zip, city, etc...)
        def update(connection, *args)
          commit(connection, "update", *args)
        end

        # customer_address.delete
        # Delete customer address
        # 
        # Return: boolean
        # 
        # Arguments:
        # 
        # int addressId - customer address ID
        def delete(connection, *args)
          commit(connection, "delete", *args)
        end
        
        def find_by_id(connection, id)
          info(connection, id)
        end

        def find_by_customer_id(connection, id)
          list(connection, id)
        end
        
    end
    
    def country(connection)
      Magento::Country.find_by_id(connection, self.country_id)
    end
    
    def region(connection)
      Magento::Region.find_by_country_and_id(connection, self.country_id, self.region_id)
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