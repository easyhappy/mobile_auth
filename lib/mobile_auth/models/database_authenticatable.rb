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

        MobileAuth::Models.config(self, :pepper, :stretches)
      end

      # Generates password encryption based on the given value.
      def password=(new_password)
        @password = new_password
        self.encrypted_password = password_digest(@password) if @password.present?
      end

      # Verifies whether an password (ie from sign in) is the user password.
      def valid_password?(password)
        return false if encrypted_password.blank?
        bcrypt   = ::BCrypt::Password.new(encrypted_password)
        password = ::BCrypt::Engine.hash_secret("#{password}#{self.class.pepper}", bcrypt.salt)
        MobileAuth.secure_compare(password, encrypted_password)
      end

      # Set password and password confirmation to nil
      def clean_up_passwords
        self.password = self.password_confirmation = nil
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