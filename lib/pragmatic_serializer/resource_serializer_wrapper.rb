module PragmaticSerializer
  module ResourceSerializerWrapper
    def self.call
      yield
    end
  end
end
