RSpec.shared_examples 'object that can access config' do
  it 'resource class should be have been extended with config interface' do
    expect(described_class.config).to be_instance_of(PragmaticSerializer::Configuration)
  end

  it 'resource have #config method accessible' do
    expect(subject.send(:config)).to be_instance_of(PragmaticSerializer::Configuration)
  end

  it 'resoucre #config should be same as .config' do
    expect(subject.send(:config)).to be described_class.config
  end

  it '.config should be same as PragmaticSerializer.config' do
    expect(described_class.config).to be PragmaticSerializer.config
  end
end
