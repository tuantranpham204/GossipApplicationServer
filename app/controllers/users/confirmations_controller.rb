# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  # def show
  #   super
  # end

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
    client_url = ENV["CLIENT_URL"] || "http://localhost:5173"
    "#{client_url}/sign_in?confirmed=true"
  end
end
