module PragmaticSerializer
  module CollectionInterface
    module ClassMethods
      def collection(resources, resource_options: {})
        PragmaticSerializer::CollectionSerializer.new
          .tap { |cs| cs.resource_serializer = self }
          .tap { |cs| cs.resources = resources }
          .tap { |cs| cs.resource_options = resource_options }
      end

      def collection_hash(resources, method=nil, resource_options: {})
        collection(resources, resource_options: resource_options)
          .tap do |cs|
            # if method is specified pass it as serailzation method
            # othervise the CollectionSerializer will use config.default_resource_serialization_method
            # which is by default :as_json
            cs.serialization_method = method if method
          end
          .as_json
      end
    end

    def self.included(base)
      base.send(:extend, ClassMethods)
    end
  end
end
