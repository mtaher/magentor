module Magento
  class Inventory < Base
    class << self
      def api_path
        "product_stock"
      end

      def list(connection, *args)
        results = commit(connection, "list", *args)
        results.collect do |result|
          new(result)
        end
      end
    end
  end
end
