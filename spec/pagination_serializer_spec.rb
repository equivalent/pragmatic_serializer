require 'spec_helper'

RSpec.describe PragmaticSerializer::PaginationJSON do
  RSpec.shared_examples 'pagination json that has first element' do
    describe '#first' do
      it  do
        expect(subject.first).to eq("/endpoint?limit=#{limit}&offset=0")
      end
    end
  end

  subject { described_class.new(limit: limit, offset: offset, pagination_evaluator: pagination_evaluator, total: total) }
  let(:limit)  { 13 }
  let(:offset) { 1 }
  let(:total) { 100 }
  let(:pagination_evaluator) { ->(limit:, offset:) { "/endpoint?limit=#{limit}&offset=#{offset}" } }

  describe '#limit' do
    it do
      expect(subject.limit).to eq limit
    end
  end

  describe '#offset' do
    it do
      expect(subject.offset).to eq offset
    end
  end

  context 'when offset is 0' do
    let(:offset) { 0 }

    it_behaves_like 'pagination json that has first element'

    describe '#prev' do
      it  do
        expect(subject.prev).to be nil
      end
    end

    describe '#next' do
      it  do
        expect(subject.next).to eq("/endpoint?limit=13&offset=13")
      end
    end

    describe '#href' do
      it  do
        expect(subject.href).to eq("/endpoint?limit=13&offset=0")
      end
    end
  end

  context 'when offset is greater than 0' do
    let(:offset) { 10 }
    let(:limit) { 5 }
    it_behaves_like 'pagination json that has first element'

    describe '#prev' do
      it  do
        expect(subject.prev).to eq("/endpoint?limit=5&offset=5")
      end
    end

    describe '#next' do
      it  do
        expect(subject.next).to eq("/endpoint?limit=5&offset=15")
      end
    end

    describe '#href' do
      it  do
        expect(subject.href).to eq("/endpoint?limit=5&offset=10")
      end
    end
  end

  describe '#as_json' do
    it do
      expect(subject.as_json).to match({
        limit: limit,
        offset: offset,
        href: subject.href,
        first: subject.first,
        next: subject.next,
        prev: subject.prev,
        total: total
      })
    end
  end
end
