require 'spec_helper'

class FooBarGISerializer
  include PragmaticSerializer::Prefixes # requirement 
  include PragmaticSerializer::GeneralInitialization
end

RSpec.describe FooBarGISerializer do
  subject { described_class.new(foo_bar_gi: model ) }
  let(:model) { double }

  context 'incorrect keyword initalize' do
    subject { described_class.new(dummy_foo: model ) }

    describe 'initialization' do
      it do
        expect { subject }.to raise_exception(ArgumentError)
      end
    end
  end

  context 'correct keyword initalize' do
    describe 'initialization' do
      it do
        expect { subject }.not_to raise_exception
      end
    end

    describe '#foo_bar_gi' do
      it do
        expect(subject.foo_bar_gi).to eq model
      end
    end
  end
end
