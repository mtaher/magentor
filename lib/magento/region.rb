module Magento
  # http://www.magentocommerce.com/wiki/doc/webservices-api/api/directory_region
  class Region < Base
    class << self
      # directory_region.list
      # List of regions in specified country
      # 
      # Return: array
      # 
      # Arguments:
      # 
      # string $country - Country code in ISO2 or ISO3
      def list(connection, *args)
        results = commit(connection, "list", *args)
        results.collect do |result|
          new(result)
        end
      end
      
      def find_by_country(connection, iso)
        list(connection, iso)
      end
      
      def find_by_country_and_id(connection, iso, id)
        list(connection, iso).select{ |r| r.id == id }.first
      end
      
      def find_by_country_iso_and_iso(connection, country_iso, iso)
        list(connection, country_iso).select{ |r| r.code == iso }.first
      end
    end
  end
end
