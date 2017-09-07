require 'spec_helper'

module API
  module V67
    class DummyWorkSerializer
      include PragmaticSerializer::All

      attr_accessor :policy

      def main_json
        {
          title: resource.title
        }
      end

      def json_href_value
        # in Rails all you have to do is:
        #
        #  `include Rails.application.routes.url_helpers`
        #
        #  and you will be able to do `root_path` ...
        #
        "/api/v67/dummy_works/#{resource.public_uid}"
      end

      def as_foo_json
        title = if policy && policy.admin?
                  "The Comedown"
                else
                  "It Never Ends"
                end

        { bmth: title }
      end
    end
  end
end

RSpec.describe API::V67::DummyWorkSerializer do
  let(:resource) { instance_double(DummyWork, public_uid: 'atreyu123', title: "Halestorm") }

  describe 'collection' do
    let(:policy_object) { double admin?: true }
    let(:options) { {} }  # no options
    subject { described_class.collection([resource], **options) }

    context 'no pagination' do
      it do
        expect(subject.as_json).to match({
          dummy_works: [
            {
              id: "atreyu123",
              type: "dummy_work",
              href: "/api/v67/dummy_works/atreyu123",
              title: "Halestorm"
            }
          ]
        })
      end
    end

    context 'with pagination' do
      before do
        subject.pagination_evaluator = ->(limit:, offset:) { "/api/v67/dummy_works?limit=#{limit}&offset=#{offset}" }
        subject.limit = 10
        subject.offset = 3
      end

      describe '#as_json' do
        it do
          expect(subject.as_json).to match({
            dummy_works: [
              {
                id: "atreyu123",
                type: "dummy_work",
                href: "/api/v67/dummy_works/atreyu123",
                title: "Halestorm"
              }
            ],
            first:  "/api/v67/dummy_works?limit=10&offset=0",
            href:   "/api/v67/dummy_works?limit=10&offset=3",
            prev:   "/api/v67/dummy_works?limit=10&offset=0",
            next:   "/api/v67/dummy_works?limit=10&offset=13",
            limit:  10,
            offset: 3,
          })
        end
      end

      describe '#as_unprefixed_json' do
        it do
          expect(subject.as_unprefixed_json).to match([
            {
              id: "atreyu123",
              type: "dummy_work",
              href: "/api/v67/dummy_works/atreyu123",
              title: "Halestorm"
            }
          ])
        end
      end
    end

    context 'specify different serialization_method' do
      before do
        subject.serialization_method = :as_foo_json
      end

      describe '#as_json' do
        it do
          expect(subject.as_json).to match({
            dummy_works: [
              { bmth: "It Never Ends"}
            ]
          })
        end

        context ' passing resource options' do
          let(:options) { { resource_options: { :'policy=' => policy_object } } }

          it do
            expect(subject.as_json).to match({
              dummy_works: [
                { bmth: "The Comedown"}
              ]
            })
          end
        end
      end

      describe '#as_unprefixed_json' do
        it do
          expect(subject.as_unprefixed_json).to match([
            { bmth: "It Never Ends"}
          ])
        end
      end
    end
  end

  describe 'collection_hash' do
    subject { described_class.collection_hash([resource], :as_foo_json) }

    it do
      expect(subject).to be_kind_of(Hash)
      expect(subject).to match({:dummy_works=>[{:bmth=>"It Never Ends"}]})
    end
  end
end
