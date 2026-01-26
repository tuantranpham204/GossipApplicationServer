# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include ApiResponder
  include ErrorHandlers
  # before_action :configure_sign_in_params, only: [:create]

  # POST /resource/sign_in
  def create
    # Find user by email first
    user = User.find_by(email: sign_in_params[:email])

    if user && user.valid_password?(sign_in_params[:password])
      sign_in(resource_name, user)
      @token = request.env["warden-jwt_auth.token"]
      yield user if block_given?
      respond_with user, location: after_sign_in_path_for(user)
    else
      # Fallback to warden authentication
      self.resource = warden.authenticate!(auth_options)
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      @token = request.env["warden-jwt_auth.token"]
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # Ensure we permit both keys to handle safe migration/stale config
  def sign_in_params
    params.require(:user).permit(:email, :password)
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  # Devise-JWT adds the token to the HEADER automatically.
  def respond_with(resource, _opts = {})
    if action_name == "create"
      yield resource if block_given?
      json_success(data: { token: @token, user_id: resource.id, username: resource.username, roles: resource.roles, firstName: resource.profile.first_name, lastName: resource.profile.last_name, avatar_url: resource.profile.avatar_data["url"] }, message: I18n.t("messages.sign_in_ok", username: @username))
    else
        # If we are here (e.g. from a 'new' action recall), it means auth failed.
        # Fallback to returning 401 if CustomDeviseFailureApp didn't intercept it.
        json_error(message: I18n.t("devise.failure.invalid", authentication_keys: "email", default: "Invalid email or password."), status: :unauthorized)
    end
  end

  def respond_to_on_destroy
    json_success(data: {}, message: I18n.t("messages.sign_out_ok", username: "User"))
  end
end
