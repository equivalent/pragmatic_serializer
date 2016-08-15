require 'spec_helper'

module API
  module V67
    class DummyWorkSerializer
      include PragmaticSerializer::All

      def main_json
        {
          title: dummy_work.title
        }
      end

      def json_href_value
        # in Rails all you have to do is:
        #
        #  `include Rails.application.routes.url_helpers`
        #
        #  and you will be able to do `root_path` ...
        #
        "/api/v67/dummy_works/#{dummy_work.public_uid}"
      end

      def as_foo_json
        { bmth: "It Never Ends"}
      end
    end
  end
end

RSpec.describe API::V67::DummyWorkSerializer do
  let(:resource) { instance_double(DummyWork, public_uid: 'atreyu123', title: "Halestorm") }
  subject { described_class.collection([resource]) }

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
          prev:   "/api/v67/dummy_works?limit=10&offset=2",
          next:   "/api/v67/dummy_works?limit=10&offset=4",
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

