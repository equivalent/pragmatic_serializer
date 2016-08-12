require 'spec_helper'

class IncludedPrefixesModelSerializer
  include PragmaticSerializer::Prefixes
end

RSpec.describe IncludedPrefixesModelSerializer do
  subject { described_class.new }

  describe '.resource_prefix' do
    it do
      expect(described_class.resource_prefix).to eq :included_prefixes_model
    end
  end

  describe '.collection_prefix' do
    it do
      expect(described_class.collection_prefix).to eq :included_prefixes_models
    end
  end

  describe '#prefix' do
    it do
      expect(subject.prefix).to eq described_class.resource_prefix
    end
  end
end
