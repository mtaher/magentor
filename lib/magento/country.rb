module Magento
  # http://www.magentocommerce.com/wiki/doc/webservices-api/api/directory_country
  class Country < Base
    class << self
      # directory_country.list
      # Retrieve list of countries.
      # 
      # Return: array.
      def list(connection)
        results = commit(connection, "list", nil)
        results.collect do |result|
          new(result)
        end
      end
      
      def all(connection)
        list(connection)
      end
      
      def find_by_id(connection, id)
        list(connection).select{ |c| c.id == id }.first
      end
      
      def find_by_iso(connection, iso)
        list(connection).select{ |c| [c.iso2_code, c.iso3_code].include? iso }.first
      end
    end
    
    def regions(connection)
      Magento::Region.find_by_country(connection, self.iso2_code)
    end
  end
end