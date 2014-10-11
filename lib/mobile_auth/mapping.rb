module MobileAuth
  class Mapping
    attr_reader :used_routes, :singular

    alias :name :singular

    def initialize(name, options)
      @singular = :user
      default_used_route options
    end

    def modules
      [:database_authenticatable, :rememberable, :recoverable, :registerable, :validatable, :trackable]
    end

    def routes
      #@routes ||= ROUTES.values_at(*self.modules).compact.uniq
      @routes = [:sessions]
    end

    private
    def default_used_route options
      @used_routes = routes
    end
  end
end