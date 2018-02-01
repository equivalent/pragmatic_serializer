require 'spec_helper'

class SerializerWithCollectionInterfaceSerializer
  include PragmaticSerializer::Prefixes
  include PragmaticSerializer::CollectionInterface

  def as_foo_json

  end
end

RSpec.describe SerializerWithCollectionInterfaceSerializer do
  let(:resource)  { double("dummy resource", public_uid: "askngalxndra") }
  let(:resources) { [resource] }

  describe '.collection' do
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

    context 'passing resource_options' do
      subject { described_class.collection(resources, resource_options: { :"dummy_method=" => 123 } ) }

      it do
        expect(subject.resource_options._registered_method_pairs)
          .to eq([[:"dummy_method=", [123], nil]])
      end
    end
  end

  describe '.collection_hash' do
    let(:collection_serializer_dummy) do
      instance_double(PragmaticSerializer::CollectionSerializer, as_json: 'stubbed hash')
    end

    before do
      expect(described_class)
        .to receive(:collection)
        .with(*cs_expected_with)
        .and_return(collection_serializer_dummy)
    end

    context 'without passing any extra args' do
      let(:cs_expected_with) { [resources, resource_options: {}] }

      def trigger
        described_class.collection_hash(resources)
      end

      it do
        expect(collection_serializer_dummy).to receive(:as_json)
        expect(trigger).to eq 'stubbed hash'
      end
    end

    context 'with method' do
      let(:cs_expected_with) { [resources, resource_options: {}] }

      def trigger
        described_class.collection_hash(resources, :as_foobar_json)
      end

      it do
        expect(collection_serializer_dummy)
          .to receive(:serialization_method=)
          .with(:as_foobar_json)
        expect(collection_serializer_dummy).to receive(:as_json)
        expect(trigger).to eq 'stubbed hash'
      end
    end

    context 'with resource_options' do
      let(:cs_expected_with) { [resources, resource_options: {foo: :bar}] }

      def trigger
        described_class.collection_hash(resources, resource_options: {foo: :bar})
      end

      it do
        expect(collection_serializer_dummy).to receive(:as_json)
        expect(trigger).to eq 'stubbed hash'
      end
    end

    context 'with resource_options and method' do
      let(:cs_expected_with) { [resources, resource_options: {foo: :bar}] }

      def trigger
        described_class.collection_hash(resources, :as_foobar_json, resource_options: {foo: :bar})
      end

      it do
        expect(collection_serializer_dummy)
          .to receive(:serialization_method=)
          .with(:as_foobar_json)
        expect(collection_serializer_dummy).to receive(:as_json)
        expect(trigger).to eq 'stubbed hash'
      end
    end
  end
end
