module PragmaticSerializer
  module CollectionInterface
    module ClassMethods
      def collection(resources, resource_options: {})
        PragmaticSerializer::CollectionSerializer.new
          .tap { |cs| cs.resource_serializer = self }
          .tap { |cs| cs.resources = resources }
          .tap { |cs| cs.resource_options = resource_options }
      end
    end

    def self.included(base)
      base.send(:extend, ClassMethods)
    end
  end
end
