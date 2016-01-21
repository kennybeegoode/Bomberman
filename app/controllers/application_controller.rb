class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :except => [:about]
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  # Configure for passing custom field that were not built in from devise.
  def configure_permitted_parameters
   devise_parameter_sanitizer.for(:sign_up){ |u| u.permit(:name, :username, :about,  :email, :password, :password_confirmation)}        
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
