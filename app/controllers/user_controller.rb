# frozen_string_literal: true

class UserController< ApplicationController
  before_action :authenticate_user! # Ensure they are logged in

  # PATCH /api/v1/users/me
  # This endpoint handles updating the User model fields (locale, timezone, etc.)
  def update_me
    # 1. Filter parameters strictly
    # We only allow updating 'locale' here.
    # You can add 'first_name', 'last_name' here later if they are on User model.
    user_params = params.require(:user).permit(:locale)

    # 2. Update the user
    if current_user.update(user_params)
      # 3. Update the context immediately for the response message
      I18n.locale = current_user.locale if user_params[:locale]

      json_success(
        data: UserSerializer.new(current_user), # We will build this next!
        message: I18n.t('messages.user_updated')
      )
    else
      json_error(
        message: I18n.t('errors.messages.validation_error'),
        status: :unprocessable_entity,
        errors: current_user.errors.as_json
      )
    end
  end
end
