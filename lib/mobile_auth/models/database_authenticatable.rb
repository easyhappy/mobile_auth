require 'bcrypt'

module MobileAuth
  # Digests the password using bcrypt.
  def self.bcrypt(klass, password)
    ::BCrypt::Password.create("#{password}#{klass.pepper}", cost: klass.stretches).to_s
  end

  module Models
    module DatabaseAuthenticatable
      # This module responsible for encrypting password and authenticate user when login

      extend ActiveSupport::Concern
      included do
        attr_reader   :password, :current_password
        attr_accessor :password_confirmation

        MobileAuth::Models.config(self, :pepper)
      end

      # Generates password encryption based on the given value.
      def password=(new_password)
        @password = new_password
        self.encrypted_password = password_digest(@password) if @password.present?
      end

      protected

      # Digests the password using bcrypt. Custom encryption should override
      # this method to apply their own algorithm.
      #
      # See https://github.com/plataformatec/devise-encryptable for examples
      # of other encryption engines.
      def password_digest(password)
        MobileAuth.bcrypt(self.class, password)
      end
    end
  end
end