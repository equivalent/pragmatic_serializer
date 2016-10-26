require 'spec_helper'
require 'ostruct'

class SerializerWithGJB
  include PragmaticSerializer::ConfigInterface
  include PragmaticSerializer::GeneralBaseJSON

  def prefix
    :document
  end

  # model accessor
  def resource
    # in spec_helper #public_uid is set te be default id field
    OpenStruct.new(public_uid: 'abc123')
  end
end

RSpec.describe SerializerWithGJB do
  subject { described_class.new }

  describe '#base_json' do
    context 'by default' do
      it do
        expect(subject.base_json).to be_kind_of(Hash)
        expect(subject.base_json).to match({
          id: "abc123",
          type: 'document'
        })
      end
    end

    context 'when href source is present' do
      before do
        expect(subject)
          .to receive(:json_href_value)
          .at_least(:once)
          .and_return('/api/v66/documents/xxx')
      end

      it do
        expect(subject.base_json).to be_kind_of(Hash)
        expect(subject.base_json).to match({
          id: "abc123",
          type: 'document',
          href: '/api/v66/documents/xxx'
        })
      end
    end

    context 'when id_source returns nil value' do
      before do
        expect(subject)
          .to receive(:resource)
          .at_least(:once)
          .and_return(double(public_uid: nil))
      end

      it do
        expect { subject.base_json }.to raise_exception(PragmaticSerializer::GeneralBaseJSON::IDHasNoValue)
      end
    end

    context 'when id_source is an integer' do
      before do
        expect(subject)
          .to receive(:resource)
          .at_least(:once)
          .and_return(double(public_uid: 123))
      end

      it 'it should return hash with id as a string' do
        expect(subject.base_json).to be_kind_of(Hash)
        expect(subject.base_json).to match({
          id: "123",
          type: 'document'
        })
      end
    end
  end
end
