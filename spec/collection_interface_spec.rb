require 'spec_helper'

class SerializerWithCollectionInterfaceSerializer
  include PragmaticSerializer::Prefixes
  include PragmaticSerializer::CollectionInterface
end

RSpec.describe SerializerWithCollectionInterfaceSerializer do
  describe '.collection' do
    let(:resources) { [double(public_uid: "askngalxndra")] }
    subject { described_class.collection(resources) }

    it do
      expect(subject).to be_kind_of(PragmaticSerializer::CollectionSerializer)
    end

    it do
      expect(subject.resource_serializer).to be SerializerWithCollectionInterfaceSerializer
    end

    it do
      expect(subject.resources).to eq resources
    end
  end
end
