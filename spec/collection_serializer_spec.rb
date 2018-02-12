require 'spec_helper'

RSpec.describe PragmaticSerializer::CollectionSerializer do
  subject { described_class.new }

  it_should_behave_like 'object that can access config'

  describe '' do
    class DummyWorkSerializer
      include PragmaticSerializer::Prefixes
      include PragmaticSerializer::GeneralInitialization

      def dummy_method=(arg)
      end

      def dummy_method_block(**options, &block)
        block.call
      end

      def as_unprefixed_json
        { doesnt: :matter } # this is tested elsewhere
      end
    end

    let(:work1) { double }
    let(:work2) { double }
    let(:prefixed_result)   { subject.as_json }
    let(:unprefixed_result) { subject.as_unprefixed_json }

    before do
      subject.resource_serializer = DummyWorkSerializer
      subject.resources = [work1, work2]
    end

    context 'given no pagination evaluator' do
      describe '#as_json' do
        it do
          expect(prefixed_result).to match({
            dummy_works: [
              be_kind_of(Hash),
              be_kind_of(Hash)
            ]
          })
        end
      end

      describe '#as_unprefixed_json' do
        it do
          expect(unprefixed_result).to match([
            be_kind_of(Hash),
            be_kind_of(Hash)
          ])
        end

        context 'passing resource_options' do
          before do
            subject.resources = [work1]
            subject.resource_options = { :"dummy_method=" => 123 }
          end

          it do
            expect_any_instance_of(DummyWorkSerializer)
              .to receive(:dummy_method=)
              .with(123)

            unprefixed_result
          end
        end

        context 'setting resource_options on instance' do
          before do
            subject.resources = [work1]
            subject.resource_options.dummy_method = 345
            @block_called = false
            subject.resource_options.dummy_method_block(trivium: "in waves") do
              @block_called = true
            end
          end

          it do
            expect_any_instance_of(DummyWorkSerializer)
              .to receive(:dummy_method=)
              .with(345)

            expect_any_instance_of(DummyWorkSerializer)
              .to receive(:dummy_method_block)
              .with(trivium: "in waves")

            unprefixed_result
          end

          it do
            unprefixed_result
            expect(@block_called).to be true
          end
        end
      end
    end

    context 'when pagination evaluator' do
      before do
        subject.pagination_evaluator = ->(limit:, offset:) { "/api/v7/dummy_works?limit=#{limit}&offset=#{offset}" }
      end

      describe '#as_json' do
        it do
          expect(prefixed_result).to match({
            dummy_works: [
              be_kind_of(Hash),
              be_kind_of(Hash)
            ],
            limit: subject.limit,
            offset: 0,
            first: "/api/v7/dummy_works?limit=#{subject.limit}&offset=0",
            prev: nil,
            next: "/api/v7/dummy_works?limit=#{subject.limit}&offset=50",
            href: "/api/v7/dummy_works?limit=#{subject.limit}&offset=0",
          })
        end

        context 'when total' do
          before do
            subject.total = 120
          end

          it do
            expect(prefixed_result).to match({
              dummy_works: [
                be_kind_of(Hash),
                be_kind_of(Hash)
              ],
              limit: subject.limit,
              offset: 0,
              first: "/api/v7/dummy_works?limit=#{subject.limit}&offset=0",
              prev: nil,
              next: "/api/v7/dummy_works?limit=#{subject.limit}&offset=50",
              href: "/api/v7/dummy_works?limit=#{subject.limit}&offset=0",
              total: 120,
            })
          end

          context 'when include_resources_json == false' do
            before { subject.include_resources_json = false }

            it 'should generate just pagination total' do
              expect(prefixed_result).to match({
                limit: subject.limit,
                offset: 0,
                first: "/api/v7/dummy_works?limit=#{subject.limit}&offset=0",
                prev: nil,
                next: "/api/v7/dummy_works?limit=#{subject.limit}&offset=50",
                href: "/api/v7/dummy_works?limit=#{subject.limit}&offset=0",
                total: 120,
              })
            end
          end
        end

        context 'when offset & limit is over total' do
          before { subject.total = 49 }

          it do
            expect(prefixed_result).to match({
              dummy_works: [
                be_kind_of(Hash),
                be_kind_of(Hash)
              ],
              limit: subject.limit,
              offset: 0,
              first: "/api/v7/dummy_works?limit=#{subject.limit}&offset=0",
              prev: nil,
              next: nil,
              href: "/api/v7/dummy_works?limit=#{subject.limit}&offset=0",
              total: 49,
            })
          end
        end
      end

      describe '#as_unprefixed_json' do
        it do
          expect(unprefixed_result).to match([
            be_kind_of(Hash),
            be_kind_of(Hash)
          ])
        end
      end
    end
  end

  describe '#serialization_method' do
    it_behaves_like 'accessor that default values to config',
      method_name: :serialization_method,
      default_method_name: :default_resource_serialization_method,
      set_to: :foo_bar,
      type_safety_klass: Symbol
  end

  describe '#offset' do
    it_behaves_like 'accessor that default values to config',
      method_name: :offset,
      set_to: 100,
      type_safety_klass: Integer
  end

  describe '#limit' do
    it_behaves_like 'accessor that default values to config',
      method_name: :limit,
      set_to: 20,
      type_safety_klass: Integer

    context 'when limit value over maximum' do
      before do
        subject.limit = PragmaticSerializer.config.max_limit + 1
      end

      it do
        expect { subject.limit }.to raise_exception(PragmaticSerializer::CollectionSerializer::OverMaximumLimit)
      end
    end
  end
end
