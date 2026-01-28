# frozen_string_literal: true

module Api
  module V1
    class UserController < ApplicationController
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
            message: I18n.t("messages.resource_updated",
                            resource: { name: I18n.t("models.user.user"), attribute: I18n.t("models.user.attribute.language"), value: current_user.locale })
          )
        else
          raise AppError.new(ErrorCode::VALIDATION_ERROR, params: { details: current_user.errors.to_s || "" })
        end
      end
    end
  end
end
