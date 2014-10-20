module MobileAuth
  module Models

    def mobile_auth *modules
      options = modules.extract_options!.dup
      selected_modules = modules.map(&:to_sym).uniq.sort_by do |s|
        MobileAuth::ALL.index(s) || -1  # follow Devise::ALL order
      end

      binding.pry
      selected_modules.each do |m|
        puts "hello"
      end
    end
  end
end