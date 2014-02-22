module Magento
  # http://www.magentocommerce.com/wiki/doc/webservices-api/api/directory_country
  class Country < Base
    class << self
      # directory_country.list
      # Retrieve list of countries.
      # 
      # Return: array.
      def list(client)
        results = commit(client, "list", nil)
        results.collect do |result|
          new(result)
        end
      end
      
      def all(client)
        list(client)
      end
      
      def find_by_id(client, id)
        list(client).select{ |c| c.id == id }.first
      end
      
      def find_by_iso(client, iso)
        list(client).select{ |c| [c.iso2_code, c.iso3_code].include? iso }.first
      end
    end
    
    def regions(client)
      Magento::Region.find_by_country(client, self.iso2_code)
    end
  end
end