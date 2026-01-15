# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  include Rack::Utils

  respond_to :json
  
  def create
    begin
      self.resource = warden.authenticate!(auth_options)

      # If successful, Devise has already set the Header.
      # We just need to render the body.
      json_success(
        data: UserSerializer.new(resource),
        message: I18n.t("devise.sessions.signed_in")
      )
    rescue => e
      raise AppError(ErrorCode::SYSTEM_ERROR_DEBUG, error_details: e.message)
    end
  end

  def destroy
    begin
      # Verify user is currently signed in via Token
      if current_user
        # Revoke Token (Devise does this automatically if JTIMatcher is setup)
        sign_out(resource_name)
        json_success(message: I18n.t("devise.sessions.signed_out"))
      else
        json_error(message: I18n.t("errors.unauthorized"), status: :unauthorized)
      end
    rescue => e
      raise AppError.new(ErrorCode::SYSTEM_ERROR_DEBUG, params: { error_details: e.message })
    end
  end

  private

  # Devise calls this method after an action (create/destroy) is done
  def respond_with(resource, _opts = {})
    # Check if the user is actually signed in successfully
    if resource.persisted?
      # SUCCESS: Return your standard wrapper
      json_success(
        data: UserSerializer.new(resource),
        message: I18n.t("devise.sessions.signed_in")
      )
    else
      # FAILURE: (Should rarely happen in session creation, but safety first)
      json_error(
        message: I18n.t("devise.failure.invalid"),
        status: :unauthorized
      )
    end
  end

  # Handle Logout (DELETE)
  def respond_to_on_destroy
    if current_user
      json_success(message: I18n.t("devise.sessions.signed_out"))
    else
      json_error(message: "User not active", status: :unauthorized)
    end
  end
end