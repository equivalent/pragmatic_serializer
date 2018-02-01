require 'forwardable'
require 'ostruct'
require 'active_support/core_ext/string/inflections'

require "pragmatic_serializer/version"
require "pragmatic_serializer/configuration"
require "pragmatic_serializer/config_interface"

require "pragmatic_serializer/prefixes"
require "pragmatic_serializer/general_initialization"
require "pragmatic_serializer/general_base_json"
require "pragmatic_serializer/general_resource_json"

require "pragmatic_serializer/pagination_json"
require "pragmatic_serializer/collection_serializer"

require "pragmatic_serializer/collection_interface"
require "pragmatic_serializer/resource_interface"

require "pragmatic_serializer/all"

module PragmaticSerializer
  def self.config
    @config ||= Configuration.new
  end
end
