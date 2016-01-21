class RegistrationsController < Devise::RegistrationsController

  before_filter :configure_permitted_parameters

  def new
    super
  end

  def create
    super
  end

  def update
    super
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:name, :email, :image)
  end
end