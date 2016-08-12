require 'spec_helper'

describe PragmaticSerializer do
  it 'has a version number' do
    expect(PragmaticSerializer::VERSION).not_to be nil
  end

  it 'has config' do
    expect(PragmaticSerializer.config).to be_kind_of PragmaticSerializer::Configuration
  end
end
