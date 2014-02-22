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
      def list(client, *args)
        results = commit(client, "list", *args)
        results.collect do |result|
          new(result)
        end
      end
      
      def find_by_country(client, iso)
        list(client, iso)
      end
      
      def find_by_country_and_id(client, iso, id)
        list(client, iso).select{ |r| r.id == id }.first
      end
      
      def find_by_country_iso_and_iso(client, country_iso, iso)
        list(client, country_iso).select{ |r| r.code == iso }.first
      end
    end
  end
end
