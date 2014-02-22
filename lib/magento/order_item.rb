module Magento
  class OrderItem < Base
    class << self            
      def find_by_order_number_and_id(connection, order_number, id)
        Magento::Order.find_by_increment_id(connection, order_number).order_items.select{ |i| i.id == id }.first
      end
      
      def find_by_order_id_and_id(connection, order_id, id)
        Magento::Order.find_by_id(connection, order_id).order_items.select{ |i| i.id == id }.first
      end
    end
    
    def id
      self.item_id
    end
    
    def order(connection)
      Magento::Order.find_by_id(connection, self.order_id)
    end
    
    def product(connection)
      Magento::Product.find_by_id_or_sku(connection, self.product_id)
    end
  end
end