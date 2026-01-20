# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include ApiResponder
  include ErrorHandlers
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  #POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    yield resource if block_given?
    json_success(data: {}, message: I18n.t("messages.sign_in_ok", username: resource.username))
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def sign_in_params
      params.require(:user).permit([:email_or_username, :password])
  end

  private

  # Devise-JWT adds the token to the HEADER automatically.
  # We just need to ensure the body returns the JSON we want.
  def respond_with(resource, _opts = {})
    json_success(data: {}, message: I18n.t("messages.sign_in_ok", username: resource.username))
  end

  def respond_to_on_destroy
    if current_user
      json_success(data: {}, message: I18n.t("messages.sign_out_ok", username: current_user.username))
    else
      raise AppError.new(ErrorCode::UNAUTHORIZED)
    end
  end
end
