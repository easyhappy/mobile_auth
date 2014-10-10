require "active_support/core_ext/object/try"
require "active_support/core_ext/hash/slice"

module ActionDispatch::Routing
  class Mapper
    def mobile_auth_for *resources
      options = resources.extract_options!
      resources.map!(:to_sym)
      resources.each do |resource|
      end
    end
  end
end