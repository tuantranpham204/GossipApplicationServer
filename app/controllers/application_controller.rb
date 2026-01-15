class ApplicationController < ActionController::API
  include Pundit::Authorization
  include ApiResponder
  include ErrorHandlers
  
  rescue_from AppError do |e|
    json_error(message: e.message, status: e.status, errors: e.errors)
  end

  # Verify that 'authorize' was called for every action,
  # EXCEPT if it's a Devise controller (Login/Signup/Password Reset)
  after_action :verify_authorized, unless: :devise_controller?
end
