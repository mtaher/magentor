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
      def list(connection, *args)
        results = commit(connection, "list", *args)
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
      def info(connection, *args)
        new(commit(connection, "info", *args))
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
      def add_comment(connection, *args)
        commit(connection, 'addComment', *args)
      end
      
      # sales_order.hold
      # Hold order
      # 
      # Return: boolean
      # 
      # Arguments:
      # 
      # string orderIncrementId - order increment id
      def hold(connection, *args)
        commit(connection, 'hold', *args)
      end
      
      # sales_order.unhold
      # Unhold order
      # 
      # Return: boolean
      # 
      # Arguments:
      # 
      # mixed orderIncrementId - order increment id
      def unhold(connection, *args)
        commit(connection, 'unhold', *args)
      end
      
      # sales_order.cancel
      # Cancel order
      # 
      # Return: boolean
      # 
      # Arguments:
      # 
      # mixed orderIncrementId - order increment id
      def cancel(connection, *args)
        commit(connection, 'cancel', *args)
      end
      
      def find_by_id(connection, id)
        find(connection, :first, {:order_id => id})
      end
      
      def find_by_increment_id(connection, id)
        info(connection, id)
      end

      def find(connection, find_type, options = {})
        filters = {}
        options.each_pair { |k, v| filters[k] = {:eq => v} }
        results = list(connection, filters)
        
        raise Magento::ApiError, "100 -> Requested order not exists." if results.blank?
        
        if find_type == :first
          info(results.first.increment_id)
        else
          results.collect do |o|
            info(connection, o.increment_id)
          end
        end
      end
    end
    
    def order_items(connection)
      self.items.collect do |item|
        Magento::OrderItem.new(connection, item)
      end
    end
    
    def shipping_address(connection)
      Magento::CustomerAddress.new(connection, @attributes["shipping_address"])
    end
    
    def billing_address(connection)
      Magento::CustomerAddress.new(connection, @attributes["billing_address"])
    end
  end
end