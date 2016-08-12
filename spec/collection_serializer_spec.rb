require 'spec_helper'

RSpec.describe PragmaticSerializer::CollectionSerializer do
  subject { described_class.new }

  it_should_behave_like 'object that can access config'

  describe '#as_main_json' do
    class DummyWorkSerializer
      include PragmaticSerializer::Prefixes
      include PragmaticSerializer::GeneralInitialization

      def as_unprefixed_main_json
        { doesnt: :matter } # this is tested elsewhere
      end
    end

    let(:work1) { double }
    let(:work2) { double }
    let(:result) { subject.as_main_json }

    before do
      subject.resource_serializer = DummyWorkSerializer
      subject.resources = [work1, work2]
    end

    context 'given no pagination evaluator' do
      it do
        expect(result).to match({
          dummy_works: [
            be_kind_of(Hash),
            be_kind_of(Hash)
          ]
        })
      end
    end

    context 'when pagination evaluator' do
      before do
        subject.pagination_evaluator = ->(limit, offset) { "/api/v7/dummy_works?limit=#{limit}&offset=#{offset}" }
      end

      it do
        expect(result).to match({
          dummy_works: [
            be_kind_of(Hash),
            be_kind_of(Hash)
          ],
          limit: 10,
          offset: 0,
          #first: '/api/v1/works?limit=10&offset=0',
          #prev: '/api/v1/works?limit=10&offset=0',
          #next: '/api/v1/works?limit=10&offset=2',
          #href: '/api/v1/works?limit=10&offset=1',
        })
      end
    end
  end

  describe '#serialization_method' do
    it_behaves_like 'accessor that default values to config',
      method_name: :serialization_method,
      default_method_name: :default_collection_serialization_method,
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

  #default_collection_serialization_method

  #xit do
    ## WorkSerializer.new(ttete.).as_jsos

    #wcs = WorkSerializer.collection

    #wcs.limit  # => 10
    #wcs.offset # => 0
    #wcs.collection = Work.where(somehing: true).limit(wcs.limit).offset(wcs.offset)


    #wcs.resource_serializer #=> WorkSerializer
    #wcs.serialization_method #=> as_unprefixed_json

    ##wcs.collection = WorkCollectionPolicy
    ##                   .new(current_user)
    ##                   .allowed_to_be_publicly_displayed( Work.where(somehing: true).limit(wcs.limit).offset(wcs.offset) )

    #wcs.as_json
    #{
      #works: [
        #{
          #id: "urlslg",
          #type: 'work',
          #href: '/api/v1/works/urlslg',
          #title: 'fooo',
          #media: []
        #}
      #],
      #limit: 10,
      #offset: 0,
      #first: '/api/v1/works?limit=10&offset=0',
      #prev: nil,
      #next: '/api/v1/works?limit=10&offset=1',
      #href: '/api/v1/works?limit=10&offset=1',
    #}




    #wcs.limit  = params[:limit] # => 10
    #wcs.offest = params[:offset] # => 1
    #wcs.collection = Work.where(somehing: true).limit(wcs.limit).offset(wcs.offset)


    #wcs.as_json
    #{
      #works: [
        #{
          #id: "urlslg",
          #type: 'work',
          #href: nil,
          #title: 'fooo',
          #media: []
        #}
      #],
      #limit: 10,
      #offset: 0,
      #first: '/api/v1/works?limit=10&offset=0',
      #prev: '/api/v1/works?limit=10&offset=0',
      #next: '/api/v1/works?limit=10&offset=2',
      #href: '/api/v1/works?limit=10&offset=1',
    #}
  #end
end
