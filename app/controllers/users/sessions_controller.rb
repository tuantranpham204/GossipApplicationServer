# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  include Rack::Utils

  respond_to :json

  private

  # Devise calls this method after an action (create/destroy) is done
  def respond_with(resource, _opts = {})
    # Check if the user is actually signed in successfully
    if resource.persisted?
      # SUCCESS: Return your standard wrapper
      json_success(
        data: UserSerializer.new(resource),
        message: I18n.t('devise.sessions.signed_in')
      )
    else
      # FAILURE: (Should rarely happen in session creation, but safety first)
      json_error(
        message: I18n.t('devise.failure.invalid'),
        status: :unauthorized
      )
    end
  end

  # Handle Logout (DELETE)
  def respond_to_on_destroy
    if current_user
      json_success(message: I18n.t('devise.sessions.signed_out'))
    else
      json_error(message: "User not active", status: :unauthorized)
    end
  end
end