require "active_support/core_ext/object/try"
require "active_support/core_ext/hash/slice"

module ActionDispatch::Routing
  class Mapper
    def mobile_auth_for *resources
      options = resources.extract_options!
      resources.map!(&:to_sym)
      resources.each do |resource|
        mapping = MobileAuth.add_mapping(resource, options)
        routes = mapping.used_routes
        mobile_auth_scope mapping.name do
          #with_devise_exclusive_scope mapping.fullpath, mapping.name, options do
          routes.each { |mod|
            send("devise_#{mod}", mapping, 'users')
          }
          #end
        end
      end
    end

    private

    def mobile_auth_scope name
      constraint = lambda do |request|
        request.env["mobile_auth.mapping"] = MobileAuth.mapping[name]
        true
      end
      constraints(constraint) do
        yield
      end
    end

    def devise_session(mapping, controllers) #:nodoc:
      resource :session, only: [], controller: :sessions, path: "" do
        post   :create,  path: '/'
        delete :destroy, path: '/', as: "destroy"
      end
    end
  end
end