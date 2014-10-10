require 'rails'
require "mobile_auth/engine"

module MobileAuth

  # The parent controller all mobile_auth controllers inherits from.
  # Defaults to ApplicationController. This should be set early
  # in the initialization process and should be set to a string.
  mattr_accessor :parent_controller
  @@parent_controller = 'ApplicationController'

  # Store scopes mappings.
  mattr_reader :mappings
  @@mappings = ActiveSupport::OrderedHash.new
end
