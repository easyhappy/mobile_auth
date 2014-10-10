Rails.application.routes.draw do

  mount MobileAuth::Engine => "/mobile_auth"
end
