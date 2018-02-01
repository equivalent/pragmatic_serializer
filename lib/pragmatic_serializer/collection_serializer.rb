module PragmaticSerializer
  class CollectionSerializer
    class ResourceOptions
      def _registered_method_pairs
        @registered_method_pairs ||= []
      end

      def _call_each_reg_method_pair(obj)
        _registered_method_pairs.each do |val|
          obj.public_send(val[0], *val[1], &val[2])
        end
      end

      def method_missing(method_name, *args, &block)
        _registered_method_pairs << [method_name, args, block]
      end
    end

    OverMaximumLimit = Class.new(StandardError)

    extend Forwardable
    include PragmaticSerializer::ConfigInterface

    attr_writer :limit, :offset, :serialization_method
    attr_accessor :resources, :total, :resource_serializer, :pagination_evaluator

    def resource_options
      @resource_options ||= ResourceOptions.new
    end

    def resource_options=(**options)
      options.each_pair do |method_name, value|
        resource_options.send(method_name, value)
      end
    end

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
      def_delegators :resource_serializer, :collection_prefix

      def collection_serializers
        resources.map do |resource|
          resource_object = resource_serializer.new(resource)
          resource_options._call_each_reg_method_pair(resource_object)
          resource_object
        end
      end

      def pagination_json
        @pagination_json ||= PragmaticSerializer::PaginationJSON.new({
          limit: limit,
          offset: offset,
          total: total,
          pagination_evaluator: pagination_evaluator
        })
      end
  end
end
