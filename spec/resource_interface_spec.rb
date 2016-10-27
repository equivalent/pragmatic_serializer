require 'spec_helper'

class SerializerWithResourceInterfaceSerializer
  include PragmaticSerializer::GeneralInitialization
  include PragmaticSerializer::ResourceInterface

  def as_foo_json

  end

  def as_json

  end

  def ==(other_ser)
    self.class == other_ser.class && resource == resource
  end
end

RSpec.describe SerializerWithResourceInterfaceSerializer do
  let(:resource) { double 'Resource Double' }

  describe '.resource' do
    it 'should initialize serializer as #new' do
      expect(described_class.resource(resource)).to eq described_class.new(resource)
    end
  end

  describe '.resource_hash' do
    def trigger(method = nil)
      if method
        described_class.resource_hash(resource, method)
      else
        described_class.resource_hash(resource)
      end
    end

    let(:serializer_double) { instance_double(described_class) }

    before do
      expect(described_class)
        .to receive(:resource)
        .with(resource)
        .and_return(serializer_double)
    end

    context 'with no method arg' do
      it 'should call serializer instance with #as_json' do
        expect(serializer_double).to receive(:as_json)
        trigger
      end
    end

    context 'with method arg' do
      it 'should call serializer instance with method arg' do
        expect(serializer_double).to receive(:as_foo_json)
        trigger(:as_foo_json)
      end
    end
  end
end
