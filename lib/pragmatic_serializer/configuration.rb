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

    # By default PragmaticSerializer is using ActiveSupport for pluralization
    # similar to Rails : ` band.pluralize => "bands"`
    #
    # https://github.com/rails/rails/blob/master/activesupport/lib/active_support/core_ext/string/inflections.rb
    #
    # If you're not using ActiveSupport for pluralization you can change this by setting your own inflector
    #
    #    PragmaticSerializer.config.pluralization_inflector = ->(str) { MyPluralizer.new.pluralize(str) }
    #
    def pluralization_inflector
      @pluralization_inflector ||= ->(str) { ActiveSupport::Inflector.pluralize(str) }
    end

    # By default PragmaticSerializer is using ActiveSupport for singularization
    # similar to Rails : `bands.singularize => "band"`
    #
    # https://github.com/rails/rails/blob/master/activesupport/lib/active_support/core_ext/string/inflections.rb
    #
    # If you're not using ActiveSupport for singularization you can change this by setting your own inflector
    #
    #    PragmaticSerializer.config.pluralization_inflector = ->(str) { MySingularizer.new.singularize(str) }
    #
    def singularization_inflector
      @pluralization_inflector ||= ->(str) { ActiveSupport::Inflector.singularize(str) }
    end
  end
end
