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
        def list(client, *args)
          results = commit(client, "list", *args)
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
        def create(client, customer_id, attributes)
          id = commit(client, "create", customer_id, attributes)
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
        def info(client, *args)
          new(commit(client, "info", *args))
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
        def update(client, *args)
          commit(client, "update", *args)
        end

        # customer_address.delete
        # Delete customer address
        # 
        # Return: boolean
        # 
        # Arguments:
        # 
        # int addressId - customer address ID
        def delete(client, *args)
          commit(client, "delete", *args)
        end
        
        def find_by_id(client, id)
          info(client, id)
        end

        def find_by_customer_id(client, id)
          list(client, id)
        end
        
    end
    
    def country(client)
      Magento::Country.find_by_id(client, self.country_id)
    end
    
    def region(client)
      Magento::Region.find_by_country_and_id(client, self.country_id, self.region_id)
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