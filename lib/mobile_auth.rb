require 'rails'
require 'active_support/core_ext/numeric/time'
require 'active_support/dependencies'
# require 'orm_adapter'
require 'set'
require 'securerandom'

module MobileAuth
  extend self

  # The parent controller all mobile_auth controllers inherits from.
  # Defaults to ApplicationController. This should be set early
  # in the initialization process and should be set to a string.
  mattr_accessor :parent_controller
  @@parent_controller = 'ApplicationController'

  # Store scopes mappings.
  mattr_reader :mappings
  @@mappings = ActiveSupport::OrderedHash.new

  # Private methods to interface with Warden.
  mattr_accessor :warden_config
  @@warden_config = nil
  @@warden_config_blocks = []

  ROUTES      = ActiveSupport::OrderedHash.new

  def add_mapping resource, options
    mapping = MobileAuth::Mapping.new(resource, options)
    @@mappings[mapping.name] = mapping
    mapping
  end

  def add_module module_name, options={}
    if route = options[:route]
      case route
      when Hash
        key, value = route.keys.first, route.values.flatten
      end
      ROUTES[module_name] = key
    end
  end
end

require 'warden'
require 'mobile_auth/modules'
require 'mobile_auth/mapping'
require 'mobile_auth/engine'
