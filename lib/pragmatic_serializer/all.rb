module PragmaticSerializer
  module All
    def self.included(base)
      base.send(:include, PragmaticSerializer::ConfigInterface)
      base.send(:include, PragmaticSerializer::Prefixes)
      base.send(:include, PragmaticSerializer::GeneralInitialization)
      base.send(:include, PragmaticSerializer::GeneralBaseJSON)
      base.send(:include, PragmaticSerializer::GeneralResourceJSON)
      base.send(:include, PragmaticSerializer::CollectionInterface)
      base.send(:include, PragmaticSerializer::ResourceInterface)
    end
  end
end
