module MobileAuth
  module Models
    extend self

    def mobile_auth *modules
      options = modules.extract_options!.dup
      selected_modules = modules.map(&:to_sym).uniq.sort_by do |s|
        MobileAuth::ALL.index(s) || -1  # follow Devise::ALL order
      end

      selected_modules.each do |m|
        mod = MobileAuth::Models.const_get(m.to_s.classify)
        include mod
      end
    end

    def config(mod, *accessors)
      class << mod ; attr_accessor :available_configs; end
      mod.available_configs = accessors
      accessors.each do |accessor|
        mod.class_eval <<-METHOD, __FILE__, __LINE__ + 1
          def self.#{accessor}
            if defined?(@#{accessor})
                @#{accessor}
              elsif superclass.respond_to?(:#{accessor})
                superclass.#{accessor}
              else
                MobileAuth.#{accessor}
            end
          end

          def self.#{accessor}=(value)
            @#{accessor} = value
          end
        METHOD

        # or
        # mod.class_eval do
        #   # create 类方法
        #   (class << self; self; end).send :define_method, accessor do

        #   end
        # end

      end
    end
  end
end