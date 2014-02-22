module Magento
  # http://www.magentocommerce.com/wiki/doc/webservices-api/api/catalog_category
  # 100  Requested store view not found.
  # 101  Requested website not found.
  # 102  Category not exists.
  # 103  Invalid data given. Details in error message.
  # 104  Category not moved. Details in error message.
  # 105  Category not deleted. Details in error message.
  # 106  Requested product is not assigned to category.
  class Category < Base
    class << self
      # catalog_category.create
      # Create new category and return its id.
      # 
      # Return: int
      # 
      # Arguments:
      # 
      # int $parentId - ID of parent category
      # array $categoryData - category data ( array(’attribute_code’⇒‘attribute_value’ )
      # mixed $storeView - store view ID or code (optional)
      def create(client, attributes)
        id = commit(client, "create", attributes)
        record = new(attributes)
        record.id = id
        record
      end

      # catalog_category.info
      # Retrieve category data
      # 
      # Return: array
      # 
      # Arguments:
      # 
      # int $categoryId - category ID
      # mixed $storeView - store view id or code (optional)
      # array $attributes - return only specified attributes (optional)
      def info(client, *args)
        new(commit(client, "info", *args))
      end

      # catalog_category.update
      # Update category
      # 
      # Return: boolean
      # 
      # Arguments:
      # 
      # int $categoryId - ID of category for updating
      # array $categoryData - category data ( array(’attribute_code’⇒‘attribute_value’ )
      # mixed storeView - store view ID or code (optional)
      def update(client, *args)
        commit(client, "update", *args)
      end

      # catalog_category.delete
      # Delete category
      # 
      # Return: boolean
      # 
      # Arguments:
      # 
      # int $categoryId - category ID
      def delete(client, *args)
        commit(client, "delete", *args)
      end

      # catalog_category.currentStore
      # Set/Get current store view
      # 
      # Return: int
      # 
      # Arguments:
      # 
      # mixed storeView - Store view ID or code.
      def current_store(client, *args)
        commit(client, "currentStore", *args)
      end

      # catalog_category.tree
      # Retrieve hierarchical tree of categories.
      # 
      # Return: array
      # 
      # Arguments:
      # 
      # int parentId - parent category id (optional)
      # mixed storeView - store view (optional)
      def tree(client, *args)
        commit(client, "tree", *args)
      end

      # catalog_category.level
      # Retrieve one level of categories by website/store view/parent category
      # 
      # Return: array
      # 
      # Arguments:
      # 
      # mixed website - website code or Id (optional)
      # mixed storeView - store view code or Id (optional)
      # mixed parentCategory - parent category Id (optional)
      def level(client, *args)
        commit(client, "level", *args)
      end

      # catalog_category.move
      # Move category in tree
      # 
      # Return: boolean
      # 
      # Arguments:
      # 
      # int $categoryId - category ID for moving
      # int $parentId - new category parent
      # int $afterId - category ID after what position it will be moved (optional)
      # 
      # NOTE Please make sure that you are not moving category to any of its own children. 
      # There are no extra checks to prevent doing it through webservices API, and you won’t 
      # be able to fix this from admin interface then
      def move(client, *args)
        commit(client, "move", *args)
      end

      # catalog_category.assignedProducts
      # Retrieve list of assigned products
      # 
      # Return: array
      # 
      # Arguments:
      # 
      # int $categoryId - category ID
      # mixed $store - store ID or code
      def assigned_products(client, *args)
        commit(client, "assignedProducts", *args)
      end

      # catalog_category.assignProduct
      # Assign product to category
      # 
      # Return: boolean
      # 
      # Arguments:
      # 
      # int $categoryId - category ID
      # mixed $product - product ID or sku
      # int $position - position of product in category (optional)
      def assign_product(client, *args)
        commit(client, "assignProduct", *args)
      end

      # catalog_category.updateProduct
      # Update assigned product
      # 
      # Return: boolean
      # 
      # Arguments:
      # 
      # int $categoryId - category ID
      # mixed $product - product ID or sku
      # int $position - position of product in category (optional)
      def update_product(client, *args)
        commit(client, "updateProduct", *args)
      end

      # catalog_category.removeProduct
      # Remove product assignment from category
      # 
      # Return: boolean
      # 
      # Arguments:
      # 
      # int $categoryId - category ID
      # mixed $product - product ID or sku
      def remove_product(client, *args)
        commit(client, "removeProduct", *args)
      end
      
      def find_by_id(client, id)
        info(client, id)
      end
    end
    
    def delete(client)
      self.class.delete(client, self.id)
    end
    
    def update_attribute(client, name, value)
      @attributes[name] = value
      self.class.update(client, self.id, Hash[*[name.to_sym, value]])
    end
    
    def update_attributes(client, attrs)
      attrs.each_pair { |k, v| @attributes[k] = v }
      self.class.update(client, self.id, attrs)
    end
    
    def assigned_products(client, *args)
      self.class.assigned_products(client, self.id, *args)
    end

    def assign_product(client, *args)
      self.class.assign_product(client, self.id, *args)
    end

    def update_product(client, *args)
      self.class.update_product(client, self.id, *args)
    end

    def remove_product(client, *args)
      self.class.remove_product(client, self.id, *args)
    end
  end
end