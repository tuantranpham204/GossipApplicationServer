
class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  def create
    begin
      user_data = params.require(:user).permit(:email, :password, :first_name, :last_name).to_h

      build_resource(sign_up_params)
      if resource.save
        # Force the token generation immediately if you want auto-login
        sign_up(resource_name, resource) if resource.active_for_authentication?

        json_success(
          data: UserSerializer.new(resource),
          message: I18n.t("devise.registrations.signed_up")
        )
      else
        # Clean up the password from memory/logs
        clean_up_passwords resource
        set_minimum_password_length

        json_error(
          message: I18n.t("errors.messages.not_saved"),
          status: :unprocessable_entity,
          errors: resource.errors.as_json
        )
      end
    rescue => e
      raise AppError.new(ErrorCode::SYSTEM_ERROR_DEBUG, params: { error_details: e.message })
    end
  end



  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      # SUCCESS: Account created
      json_success(
        data: UserSerializer.new(resource),
        message: I18n.t("devise.registrations.signed_up")
      )
    else
      # FAILURE: Validation errors (e.g. Password too short)
      # We use resource.errors to populate the 'errors' field
      json_error(
        message: I18n.t("errors.messages.not_saved"),
        status: :unprocessable_entity,
        errors: resource.errors.as_json
      )
    end
  end
end