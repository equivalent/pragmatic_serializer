module PragmaticSerializer
  class CollectionSerializer
    OverMaximumLimit = Class.new(StandardError)

    extend Forwardable
    include PragmaticSerializer::ConfigInterface

    attr_writer :limit, :offset, :serialization_method, :resource_options
    attr_accessor :resources, :resource_serializer, :pagination_evaluator

    def serialization_method
      @serialization_method ||= config.default_resource_serialization_method
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
      hash = { collection_prefix => as_unprefixed_json }
      hash.merge!(pagination_json.as_json) if pagination_evaluator
      hash
    end

    def as_unprefixed_json
      collection_serializers.map { |rs| rs.send(serialization_method) }
    end

    private
      def_delegators :resource_serializer, :resource_prefix, :collection_prefix

      def collection_serializers
        resources.map do |resource|
          resource_object = resource_serializer.new(resource_prefix => resource)

          resource_options.each do |method_name, value|
            puts "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
            puts method_name
            puts value
            resource_object.send(method_name, value)
          end

          resource_object
        end
      end

      def pagination_json
        @pagination_json ||= PragmaticSerializer::PaginationJSON.new({
          limit: limit,
          offset: offset,
          pagination_evaluator: pagination_evaluator
        })
      end

      def resource_options
        @resource_options ||= {}
      end
  end
end
