module Magento
  class Order < Base
    # http://www.magentocommerce.com/wiki/doc/webservices-api/api/sales_order
    # 100  Requested order not exists.
    # 101  Invalid filters given. Details in error message.
    # 102  Invalid data given. Details in error message.
    # 103  Order status not changed. Details in error message.
    class << self      
      # sales_order.list
      # Retrieve list of orders by filters
      # 
      # Return: array
      # 
      # Arguments:
      # 
      # array filters - filters for order list (optional)
      def list(client, *args)
        results = commit(client, "list", *args)
        results.collect do |result|
          new(result)
        end
      end
      
      # sales_order.info
      # Retrieve order information
      # 
      # Return: array
      # 
      # Arguments:
      # 
      # string orderIncrementId - order increment id
      def info(client, *args)
        new(commit(client, "info", *args))
      end
      
      # sales_order.addComment
      # Add comment to order
      # 
      # Return: boolean
      # 
      # Arguments:
      # 
      # string orderIncrementId - order increment id
      # string status - order status
      # string comment - order comment (optional)
      # boolean notify - notification flag (optional)
      def add_comment(client, *args)
        commit(client, 'addComment', *args)
      end
      
      # sales_order.hold
      # Hold order
      # 
      # Return: boolean
      # 
      # Arguments:
      # 
      # string orderIncrementId - order increment id
      def hold(client, *args)
        commit(client, 'hold', *args)
      end
      
      # sales_order.unhold
      # Unhold order
      # 
      # Return: boolean
      # 
      # Arguments:
      # 
      # mixed orderIncrementId - order increment id
      def unhold(client, *args)
        commit(client, 'unhold', *args)
      end
      
      # sales_order.cancel
      # Cancel order
      # 
      # Return: boolean
      # 
      # Arguments:
      # 
      # mixed orderIncrementId - order increment id
      def cancel(client, *args)
        commit(client, 'cancel', *args)
      end
      
      def find_by_id(client, id)
        find(client, :first, {:order_id => id})
      end
      
      def find_by_increment_id(client, id)
        info(client, id)
      end

      def find(client, find_type, options = {})
        filters = {}
        options.each_pair { |k, v| filters[k] = {:eq => v} }
        results = list(client, filters)
        
        raise Magento::ApiError, "100 -> Requested order not exists." if results.blank?
        
        if find_type == :first
          info(results.first.increment_id)
        else
          results.collect do |o|
            info(client, o.increment_id)
          end
        end
      end
    end
    
    def order_items(client)
      self.items.collect do |item|
        Magento::OrderItem.new(client, item)
      end
    end
    
    def shipping_address(client)
      Magento::CustomerAddress.new(client, @attributes["shipping_address"])
    end
    
    def billing_address(client)
      Magento::CustomerAddress.new(client, @attributes["billing_address"])
    end
  end
end