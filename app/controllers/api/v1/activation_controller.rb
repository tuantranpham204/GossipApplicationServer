# frozen_string_literal: true

class ActivationController < ApplicationController
  VALID_STATES = %w[success already invalid].freeze

  def show
    @state = params[:state]
    return head :not_found unless VALID_STATES.include?(@state)

    @title, @message = case @state
                       when "success"
                         ["Account confirmed", "Your email has been confirmed. You can sign in now."]
                       when "already"
                         ["Already confirmed", "This account was already confirmed. You can sign in."]
                       else
                         ["Invalid or expired link", "The confirmation link is invalid or has expired. You can request a new confirmation email."]
                       end

    @client_sign_in = sign_in_url
  end

  private

  def sign_in_url
    base = ENV["CLIENT_SYSTEM_URL"] || ENV["CLIENT_URL"] || "http://localhost:5173"
    "#{base}/sign_in"
  end
end
