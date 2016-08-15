require 'spec_helper'

class GeneralResourceJSONSerializer
  include PragmaticSerializer::GeneralResourceJSON

  def prefix
    'document'
  end

  def base_json
    {
      id: 'bmth',
      type: 'document'
    }
  end

  def main_json
    {
      title: 'Oli S. Sky'
    }
  end
end

RSpec.describe GeneralResourceJSONSerializer do
  subject { described_class.new }

  describe '#as_json' do
    it do
      expect(subject.as_json).to match({
        document: {
          :id=>"bmth",
          :type=>"document",
          :title=>"Oli S. Sky"
        }
      })
    end
  end

  describe '#as_base_json' do
    it do
      expect(subject.as_base_json).to match({
        document: {
          :id=>"bmth",
          :type=>"document",
        }
      })
    end
  end

  describe '#as_unprefixed_json' do
    it do
      expect(subject.as_unprefixed_json).to match({
        id:"bmth",
        type:"document",
        title: 'Oli S. Sky'
      })
    end
  end
end

