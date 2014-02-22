module Magento
  # http://www.magentocommerce.com/wiki/doc/webservices-api/api/sales_order_shipment
  # 100  Requested shipment not exists.
  # 101  Invalid filters given. Details in error message.
  # 102  Invalid data given. Details in error message.
  # 103  Requested order not exists.
  # 104  Requested tracking not exists.
  # 105  Tracking not deleted. Details in error message.
  class Shipment < Base
    class << self      
      # sales_order_shipment.list
      # Retrieve list of shipments by filters
      # 
      # Return: array
      # 
      # Arguments:
      # 
      # array filters - filters for shipments list
      def list(connection, *args)
        results = commit(connection, "list", *args)
        results.collect do |result|
          new(result)
        end
      end
      
      # sales_order_shipment.info
      # Retrieve shipment information
      # 
      # Return: array
      # 
      # Arguments:
      # 
      # string shipmentIncrementId - order shipment increment id
      def info(connection, *args)
        new(commit(connection, "info", *args))
      end
      
      # sales_order_shipment.create
      # Create new shipment for order
      # 
      # Return: string - shipment increment id
      # 
      # Arguments:
      # 
      # string orderIncrementId - order increment id
      # array itemsQty - items qty to ship as associative array (order_item_id ⇒ qty)
      # string comment - shipment comment (optional)
      # boolean email - send e-mail flag (optional)
      # boolean includeComment - include comment in e-mail flag (optional)
      def create(connection, *args)
        id = commit(connection, "create", *args)
        record = info(id)
        record
      end
      
      # sales_order_shipment.addComment
      # Add new comment to shipment
      # 
      # Return: boolean
      # 
      # Arguments:
      # 
      # string shipmentIncrementId - shipment increment id
      # string comment - shipment comment
      # boolean email - send e-mail flag (optional)
      # boolean includeInEmail - include comment in e-mail flag (optional)
      def add_comment(connection, *args)
        commit(connection, 'addComment', *args)
      end
      
      # sales_order_shipment.addTrack
      # Add new tracking number
      # 
      # Return: int
      # 
      # Arguments:
      # 
      # string shipmentIncrementId - shipment increment id
      # string carrier - carrier code
      # string title - tracking title
      # string trackNumber - tracking number
      def add_track(connection, *args)
        commit(connection, 'addTrack', *args)
      end
      
      # sales_order_shipment.removeTrack
      # Remove tracking number
      # 
      # Return: boolean
      # 
      # Arguments:
      # 
      # string shipmentIncrementId - shipment increment id
      # int trackId - track id
      def remove_track(connection, *args)
        commit(connection, 'removeTrack', *args)
      end
      
      # sales_order_shipment.getCarriers
      # Retrieve list of allowed carriers for order
      # 
      # Return: array
      # 
      # Arguments:
      # 
      # string orderIncrementId - order increment id
      def get_carriers(connection, *args)
        commit(connection, 'getCarriers', *args)
      end
      
      def find_by_id(connection, id)
        info(connection, id)
      end
      
      def find(connection, find_type, options = {})
        filters = {}
        options.each_pair { |k, v| filters[k] = {:eq => v} }
        results = list(filters)
        
        raise Magento::ApiError, "100  Requested shipment not exists." if results.blank?
        
        if find_type == :first
          info(connection, results.first.increment_id)
        else
          results.collect do |s|
            info(connection, s.increment_id)
          end
        end
        
      end
      
      def api_path
        "order_shipment"
      end
    end
  end
end