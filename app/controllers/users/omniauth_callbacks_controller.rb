# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include ApiResponder
  include ErrorHandlers

  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Google"
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url, alert: "Failed to create user from Google OAuth"
    end
  rescue StandardError => e
    Rails.logger.error("OmniAuth Google error: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    redirect_to new_user_registration_url, alert: "An error occurred during sign in. Please try again."
  end

  def failure
    redirect_to root_path, alert: "Authentication failed"
  end
end
