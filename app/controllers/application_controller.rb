class ApplicationController < ActionController::API
  include Pundit::Authorization
  include ApiResponder
  include ErrorHandlers
  include JwtService
  include ActionController::Flash
  # before_action :devise_parameter_sanitizer # This is not needed and was likely incorrect usage


  # Verify that 'authorize' was called for every action,
  # EXCEPT if it's a Devise controller (Login/Signup/Password Reset)
  after_action :verify_authorized, unless: :devise_controller?

  # def authenticate_request
  #   header = request.headers['Authorization']
  #   token = header.split(' ').last if header
  #   decoded = decode_token(token)
  #   if decoded
  #     @current_user = User.find(decoded[:user_id])
  #   else
  #     raise AppError.new(ErrorCode::UNAUTHORIZED)
  #   end
  # end


  protected

  # Removing the overridden devise_parameter_sanitizer because it was creating a new instance
  # every time, causing the configuration in RegistrationsController to be lost.
  # Devise provides a default implementation that works correctly.
  
  # def devise_parameter_sanitizer
  #   if resource_class == User
  #     Devise::ParameterSanitizer.new(User, :user, params)
  #   else
  #     super # Use the default one
  #   end
  # end
end
