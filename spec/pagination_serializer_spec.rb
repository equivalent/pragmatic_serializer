require 'spec_helper'
RSpec.describe PragmaticSerializer::PaginationJSON do
  RSpec.shared_examples 'pagination json that has first element' do
    describe '#first' do
      it  do
        expect(subject.first).to eq("/endpoint?limit=#{limit}&offset=0")
      end
    end
  end

  subject { described_class.new(limit: limit, offset: offset, pagination_evaluator: pagination_evaluator) }
  let(:limit)  { 13 }
  let(:offset) { 1 }
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
        expect(subject.next).to eq("/endpoint?limit=#{limit}&offset=1")
      end
    end

    describe '#href' do
      it  do
        expect(subject.href).to eq("/endpoint?limit=#{limit}&offset=0")
      end
    end
  end

  context 'when offset is 1' do
    it_behaves_like 'pagination json that has first element'

    describe '#prev' do
      it  do
        expect(subject.prev).to eq("/endpoint?limit=#{limit}&offset=0")
      end
    end

    describe '#next' do
      it  do
        expect(subject.next).to eq("/endpoint?limit=#{limit}&offset=2")
      end

      context 'when maximum offset is set to 1' do
        before do
          subject.maximum_offset = 1
        end

        it_behaves_like 'pagination json that has first element'

        it do
          expect(subject.next).to be nil
        end
      end
    end

    describe '#href' do
      it  do
        expect(subject.href).to eq("/endpoint?limit=#{limit}&offset=1")
      end
    end
  end

  context 'when offset is 2' do
    let(:offset) { 2 }

    it_behaves_like 'pagination json that has first element'

    describe '#prev' do
      it  do
        expect(subject.prev).to eq("/endpoint?limit=#{limit}&offset=1")
      end
    end

    describe '#next' do
      it  do
        expect(subject.next).to eq("/endpoint?limit=#{limit}&offset=3")
      end
    end

    describe '#href' do
      it  do
        expect(subject.href).to eq("/endpoint?limit=#{limit}&offset=2")
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
      })
    end
  end
end
