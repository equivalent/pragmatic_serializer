$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pragmatic_serializer'

Dir["./spec/support/shared_examples/**/*.rb"].sort.each { |f| require f}

PragmaticSerializer.config.default_id_source = :public_uid

class DummyWork
  attr_accessor :public_uid
  attr_accessor :title
end
