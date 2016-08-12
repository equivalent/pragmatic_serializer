module PragmaticSerializer
  module ConfigInterface
    module ClassMethods
      def config
        PragmaticSerializer.config
      end
    end

    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    protected

    def config
      self.class.config
    end
  end
end
