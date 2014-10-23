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

  # Used to encrypt password. Please generate one with rake secret.
  mattr_accessor :pepper
  @@pepper = nil

  # The number of times to encrypt password.
  mattr_accessor :stretches
  @@stretches = 10

  ALL         = []
  ROUTES      = ActiveSupport::OrderedHash.new

  def add_mapping resource, options
    mapping = MobileAuth::Mapping.new(resource, options)
    @@mappings[mapping.name] = mapping
    mapping
  end

  def add_module module_name, options={}
    ALL << module_name
    if route = options[:route]
      case route
      when Hash
        key, value = route.keys.first, route.values.flatten
      end
      ROUTES[module_name] = key
    end

    if options[:model] == true
      path = "mobile_auth/models/#{module_name}"
      camelized = ActiveSupport::Inflector.camelize(module_name.to_s)
      MobileAuth::Models.send(:autoload, camelized.to_sym, path)
      puts "xiaobei"
    end
  end

  # constant-time comparison algorithm to prevent timing attacks
  def self.secure_compare(a, b)
    return false if a.blank? || b.blank? || a.bytesize != b.bytesize
    l = a.unpack "C#{a.bytesize}"

    res = 0
    b.each_byte { |byte| res |= byte ^ l.shift }
    res == 0
  end

  class Getter
    def initialize name
      @name = name
    end

    def get
      ActiveSupport::Dependencies.constantize(@name)
    end
  end

  def ref(arg)
    if defined? ActiveSupport::Dependencies::ClassCache
      ActiveSupport::Dependencies::reference(arg)
      Getter.new(arg)
    else
      ActiveSupport::Dependencies.ref(arg)
    end
  end
end

require 'warden'
require 'mobile_auth/models'
require 'mobile_auth/modules'
require 'mobile_auth/mapping'
require 'mobile_auth/engine'

# require 'orm_adapter/adapters/active_record'
ActiveRecord::Base.extend MobileAuth::Models