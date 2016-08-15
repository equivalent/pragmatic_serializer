require 'spec_helper'

class DummyWork
  attr_accessor :public_uid
  attr_accessor :title
end

module API
  module V66
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
        "/api/v66/dummy_works/#{dummy_work.public_uid}"
      end
    end
  end
end

RSpec.describe API::V66::DummyWorkSerializer do
  subject { described_class.new(dummy_work: dummy_work) }
  let(:dummy_work) { instance_double(DummyWork, title: 'Foo Bar', public_uid: 1235) }

  it_should_behave_like 'object that can access config'

  describe "#as_main_json" do
    it do
      expect(subject.as_main_json).to match({
        dummy_work: {
          id: "1235",
          type: "dummy_work",
          href: "/api/v66/dummy_works/1235",
          title: "Foo Bar",
        }
      })
    end
  end

  describe "#as_base_json" do
    it do
      expect(subject.as_base_json).to match({
        dummy_work: {
          id: "1235",
          type: "dummy_work",
          href: "/api/v66/dummy_works/1235",
        }
      })
    end
  end

  describe "#as_unprefixed_main_json" do
    it do
      expect(subject.as_unprefixed_main_json).to match({
        id: "1235",
        type: "dummy_work",
        href: "/api/v66/dummy_works/1235",
        title: "Foo Bar",
      })
    end
  end
end