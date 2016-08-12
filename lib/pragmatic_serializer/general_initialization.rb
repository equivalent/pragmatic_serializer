module PragmaticSerializer
  module GeneralInitialization
    def self.included(base)
      base.send(:attr_reader, base.resource_prefix)
    end

    def initialize(**options)
      value = options.fetch(prefix) do |x|
        raise ArgumentError.new("missing keyword: #{x}")
      end
      instance_variable_set("@#{prefix}", value)
    end
  end
end
