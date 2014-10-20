module MobileAuth
  class Mapping
    attr_reader :used_routes, :singular

    alias :name :singular

    def initialize(name, options)
      @singular = :user

      @class_name = (options[:class_name] || name.to_s.classify).to_s
      @klass = MobileAuth.ref(@class_name)

      default_used_route options
    end

    def to
      @klass.get
    end

    def modules
      #[:database_authenticatable, :rememberable, :recoverable, :registerable, :validatable, :trackable]
      require 'pry'
      [:database_authenticatable]
    end

    def routes
      #@routes ||= ROUTES.values_at(*self.modules).compact.uniq
      @routes ||= ROUTES.values_at(*self.modules).compact.uniq
    end

    private
    def default_used_route options
      @used_routes = routes
    end
  end
end