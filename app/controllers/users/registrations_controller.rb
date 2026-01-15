
class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      # SUCCESS: Account created
      json_success(
        data: UserSerializer.new(resource),
        message: I18n.t('devise.registrations.signed_up')
      )
    else
      # FAILURE: Validation errors (e.g. Password too short)
      # We use resource.errors to populate the 'errors' field
      json_error(
        message: I18n.t('errors.messages.not_saved'),
        status: :unprocessable_entity,
        errors: resource.errors.as_json
      )
    end
  end
end