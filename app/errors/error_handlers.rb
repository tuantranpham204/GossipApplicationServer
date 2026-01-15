module ErrorHandlers
  extend ActiveSupport::Concern

  included do
    # 1. Custom Application Errors (The "Expected" Errors)
    rescue_from AppError, with: :handle_app_error

    # 2. Rails/ActiveRecord Errors (The "Built-in" Errors)
    rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
    rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
    rescue_from ActionController::ParameterMissing, with: :handle_missing_param

    # 3. Pundit Authorization Errors
    rescue_from Pundit::NotAuthorizedError, with: :handle_unauthorized

    # 4. The "Safety Net" (Catch-all for 500 crashes)
    # This must be LAST in the list to prioritize specific errors above.
    rescue_from StandardError, with: :handle_standard_error
  end

  private

  # --- Handler for your custom AppError ---
  def handle_app_error(e)
    json_error(
      message: e.message,
      status: e.status,
      code: e.code,
      errors: e.errors
    )
  end

  # --- Handler for Missing Params (400) ---
  def handle_missing_param(e)
    # This happens when params.require(:user) fails
    json_error(
      message: I18n.t("errors.missing_param", param: e.param),
      status: :bad_request
    )
  end
  

  # --- Handler for Pundit (403) ---
  def handle_unauthorized(e)
    json_error(
      message: I18n.t("errors.unauthorized"),
      status: :forbidden
    )
  end

  # --- The Safety Net (500) ---
  def handle_standard_error(e)
    # 1. Log the error (Essential for debugging!)
    Rails.logger.error("\n\n🛑 SYSTEM ERROR: #{e.class} - #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    Rails.logger.error("\n")

    # 2. Determine Message
    # In Development: Show the real error message for easy fix
    # In Production: Show "Internal Server Error" to hide sensitive code
    message = if Rails.env.development? || Rails.env.test? then I18n.t("errors.internal_server_error_debug", params: { error_details: "#{e.class}: #{e.message}" }) else I18n.t("errors.internal_server_error") end

    # 3. Return JSON
    json_error(
      message: message,
      status: :internal_server_error,
      code: 500
    )
  end
end