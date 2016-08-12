module PragmaticSerializer
  module Prefixes
    module ClassMethods
      def collection_prefix
        name.demodulize.underscore.gsub('_serializer', '').pluralize.to_sym
      end

      def resource_prefix
        name.demodulize.underscore.gsub('_serializer', '').singularize.to_sym
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
