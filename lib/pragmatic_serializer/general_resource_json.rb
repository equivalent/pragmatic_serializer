module PragmaticSerializer
  module GeneralResourceJSON
    def as_unprefixed_main_json
      base_json.merge(main_json)
    end

    def as_main_json
      {
        prefix.to_sym => as_unprefixed_main_json
      }
    end

    def as_base_json
      {
        prefix.to_sym => base_json
      }
    end
  end
end
