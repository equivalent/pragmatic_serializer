module PragmaticSerializer
  class CollectionSerializer
    OverMaximumLimit = Class.new(StandardError)

    extend Forwardable
    include PragmaticSerializer::ConfigInterface

    attr_writer :limit, :offset, :serialization_method
    attr_accessor :resources, :resource_serializer

    def serialization_method
      @serialization_method ||= config.default_collection_serialization_method
    end

    def limit
      @limit ||= config.default_limit
      raise OverMaximumLimit if @limit > config.max_limit
      @limit
    end

    def offset
      @offset ||= config.default_offset
    end

    def as_json
      {
        collection_prefix => collection_serializers.map(&:as_unprefixed_main_json),
      }.merge(limit_json)
    end

    private
      def_delegators :resource_serializer, :resource_prefix, :collection_prefix

      def collection_serializers
        resources.map do |resource|
          resource_serializer.new(resource_prefix => resource)
        end
      end

      def limit_json
        {
          limit: 10,
          offset: 0
        }
      end
  end
end
