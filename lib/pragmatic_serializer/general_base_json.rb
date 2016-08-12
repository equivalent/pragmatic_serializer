module PragmaticSerializer
  module GeneralBaseJSON
    IDHasNoValue = Class.new(StandardError)

    def base_json
      {
        "id": (json_id_value).to_s,
        "type": json_type_value,
      }
        .tap do |hash|
          hash.merge!(href: json_href_value) if json_href_value
        end
    end

    protected

    def json_id_value
      send(prefix).send(json_id_source) || raise(IDHasNoValue)
    end

    def json_id_source
      config.default_id_source
    end

    def json_type_value
      prefix.to_s
    end

    def json_href_value;end
  end
end
