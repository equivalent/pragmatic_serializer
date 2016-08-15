module PragmaticSerializer
  module CollectionInterface
    module ClassMethods
      def collection(resources)
        PragmaticSerializer::CollectionSerializer.new
          .tap { |cs| cs.resource_serializer = self }
          .tap { |cs| cs.resources = resources }
      end
    end

    def self.included(base)
      base.send(:extend, ClassMethods)
    end
  end
end
