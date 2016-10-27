module PragmaticSerializer
  module ResourceInterface
    module ClassMethods
      # initialize new resource serializer
      #
      # this method exist for consistency purpose with CollectionInterface
      def resource(resource)
        self.new(resource)
      end

      def resource_hash(resource, method=:as_json)
        resource(resource).send(method)
      end
    end

    def self.included(base)
      base.send(:extend, ClassMethods)
    end
  end
end
