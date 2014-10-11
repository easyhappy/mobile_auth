require 'mobile_auth/rails/routes'
require 'mobile_auth/rails/warden_compat'

module MobileAuth
  class Engine < ::Rails::Engine
    # isolate_namespace MobileAuth
    config.devise = MobileAuth #什么用

    # Initialize Warden and copy its configurations.
    config.app_middleware.use Warden::Manager do |config|
      MobileAuth.warden_config = config
    end

    # Force routes to be loaded if we are doing any eager load.
    config.before_eager_load { |app| app.reload_routes! }
  end
end
