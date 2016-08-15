module PragmaticSerializer
  class Configuration
    attr_writer :default_id_source

    def default_offset
      0
    end

    def default_limit
      50
    end

    def max_limit
      200
    end

    def default_id_source
      @default_id_source ||= :id
    end

    def default_resource_serialization_method
      :as_unprefixed_json
    end
  end
end
