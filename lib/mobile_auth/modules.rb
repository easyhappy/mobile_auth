require 'active_support/core_ext/object/with_options'

MobileAuth.with_options model: true do |d|
  d.with_options strategy: true do |s|
    routes = [nil, :new, :strategy]
    MobileAuth.add_module :database_authenticatable, controller: :sessions, route: { session: routes }
  end
end