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

  def add_mapping resource, options
    mapping = MobileAuth::Mapping.new(resource, options)
    @@mappings[mapping.name] = mapping
    mapping
  end
end

require 'warden'
require 'mobile_auth/mapping'
require 'mobile_auth/engine'
