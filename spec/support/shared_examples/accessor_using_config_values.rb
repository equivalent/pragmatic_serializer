RSpec.shared_examples 'accessor that default values to config' do |method_name:, set_to:, type_safety_klass: nil, default_method_name: nil|
  let(:result) { subject.send(method_name) }
  let(:default_value) { PragmaticSerializer.config.send(default_method_name || "default_#{method_name}") }

  context 'by default' do
    it 'use config default value' do
      expect(result).to be_kind_of(type_safety_klass) if type_safety_klass
      expect(result).to eq default_value
    end
  end

  context 'when set custom value' do
    before do
      subject.send("#{method_name}=", set_to)
    end

    it "use that value" do
      expect(result).to be set_to
    end
  end
end
