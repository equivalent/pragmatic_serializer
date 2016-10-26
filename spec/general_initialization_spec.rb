require 'spec_helper'

class FooBarGISerializer
  include PragmaticSerializer::Prefixes # requirement 
  include PragmaticSerializer::GeneralInitialization
end

RSpec.describe FooBarGISerializer do
  subject { described_class.new(model) }
  let(:model) { double }

  context 'correct keyword initalize' do
    describe 'initialization' do
      it do
        expect { subject }.not_to raise_exception
      end
    end

    describe '#foo_bar_gi' do
      it do
        expect(subject.resource).to eq model
      end
    end
  end
end
