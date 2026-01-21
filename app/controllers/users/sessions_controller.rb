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
    super
    @token = request.env['warden-jwt_auth.token']
    @username = resource.username
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
  def respond_with(resource, _opts = {})
    yield resource if block_given? 
    json_success(data: { token: @token, username: @username }, message: I18n.t("messages.sign_in_ok", username: @username))
  end

  def respond_to_on_destroy
    if current_user
      json_success(data: {}, message: I18n.t("messages.sign_out_ok", username: current_user.username))
    else
      raise AppError.new(ErrorCode::UNAUTHORIZED)
    end
  end
end
