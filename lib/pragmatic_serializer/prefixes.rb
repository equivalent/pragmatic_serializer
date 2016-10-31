module PragmaticSerializer
  module Prefixes
    module ClassMethods
      def collection_prefix
        PragmaticSerializer.config.pluralization_inflector.call(resource_base_name).to_sym
      end

      def resource_prefix
        PragmaticSerializer.config.singularization_inflector.call(resource_base_name).to_sym
      end

      private

      def resource_base_name
        name.demodulize.underscore.gsub('_serializer', '')
      end
    end

    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    def prefix
      self.class.resource_prefix
    end
  end
end
