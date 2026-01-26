# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  include ApiResponder
  include ErrorHandlers
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    client_url = ENV["CLIENT_SYSTEM_URL"] || "http://localhost:5173"

    token = params[:confirmation_token]
    if token.blank?
      return redirect_to "#{client_url}/activation-status?confirmed=invalid"
    end

    self.resource = resource_class.confirm_by_token(token)

    if resource.errors.empty?
      # Success path
      redirect_to after_confirmation_path_for(resource_name, resource)
    elsif resource.errors.of_kind?(:email, :already_confirmed)
      # Already confirmed – redirect to client with status
      redirect_to "#{client_url}/activation-status?confirmed=already"
    else
      # Invalid or expired token
      redirect_to "#{client_url}/activation-status?confirmed=invalid"
    end
  end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    # Redirect to a frontend login page or a simple success page
    # showing a flash message.
    # For now, we'll redirect to a client login URL if configured,
    # or a generic success message.
    client_url = ENV["CLIENT_SYSTEM_URL"] ||"http://localhost:5173"
    "#{client_url}/activation-status?confirmed=true"
  end
end
