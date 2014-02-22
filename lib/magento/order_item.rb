module Magento
  class OrderItem < Base
    class << self            
      def find_by_order_number_and_id(client, order_number, id)
        Magento::Order.find_by_increment_id(client, order_number).order_items.select{ |i| i.id == id }.first
      end
      
      def find_by_order_id_and_id(client, order_id, id)
        Magento::Order.find_by_id(client, order_id).order_items.select{ |i| i.id == id }.first
      end
    end
    
    def id
      self.item_id
    end
    
    def order(client)
      Magento::Order.find_by_id(client, self.order_id)
    end
    
    def product(client)
      Magento::Product.find_by_id_or_sku(client, self.product_id)
    end
  end
end