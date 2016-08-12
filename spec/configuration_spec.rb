require 'spec_helper'
RSpec.describe PragmaticSerializer::Configuration do
  subject { described_class.new }

  describe '#max_limit' do
    it do
      expect(subject.max_limit).to eq 200
    end
  end

  describe '#default_limit' do
    it do
      expect(subject.default_limit).to eq 50
    end
  end

  describe '#default_offset' do
    it do
      expect(subject.default_offset).to eq 0
    end
  end

  describe '#default_id_source' do
    it do
      expect(subject.default_id_source).to eq :id
    end

    context 'after setting custom value' do
      before do
        subject.default_id_source = :foo_bar
      end

      it do
        expect(subject.default_id_source).to eq :foo_bar
      end
    end
  end

  describe '#default_collection_serialization_method' do
    it do
      expect(subject.default_collection_serialization_method).to eq :as_unprefixed_main_json
    end
  end
end
