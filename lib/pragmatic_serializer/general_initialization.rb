module PragmaticSerializer
  module GeneralInitialization
    def self.included(base)
      base.send(:attr_reader, :resource)
    end

    def initialize(resource)
      @resource = resource
    end
  end
end
