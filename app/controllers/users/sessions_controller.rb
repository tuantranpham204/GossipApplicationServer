# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include ApiResponder
  include ErrorHandlers
  # before_action :configure_sign_in_params, only: [:create]

  #POST /resource/sign_in
  def create
    super
    @token = request.env['warden-jwt_auth.token']
    @username = resource.username
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
    if action_name == 'create'
      yield resource if block_given?
      json_success(data: { token: @token, username: @username }, message: I18n.t("messages.sign_in_ok", username: @username))
    else
        # If we are here (e.g. from a 'new' action recall), it means auth failed.
        # Fallback to returning 401 if CustomDeviseFailureApp didn't intercept it.
        json_error(message: I18n.t("devise.failure.invalid", authentication_keys: "email/username", default: "Invalid email or password."), status: :unauthorized)
    end
  end

  def respond_to_on_destroy
    if current_user
      json_success(data: {}, message: I18n.t("messages.sign_out_ok", username: current_user.username))
    else
      json_error(message: I18n.t("devise.failure.unauthenticated", default: "You need to sign in or sign up before continuing."), status: :unauthorized)
    end
  end
end
