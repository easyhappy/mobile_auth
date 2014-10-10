class MobileAuth::RegistrationsController < MobileAuthController
  def create
    #build_resource
  end

  private
  def build_resource hash={}
    resource_class = User # 后期改为 可配置的
    self.resource = resource_class.new_with_session(hash || {}, session)
  end
end