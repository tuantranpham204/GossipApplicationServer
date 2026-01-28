module ErrorHandlers
  extend ActiveSupport::Concern

  included do
    # Handle known application errors (expected logic failures)
    # Handle unexpected system errors (bugs, crashes)
    rescue_from StandardError, with: :handle_standard_error

    rescue_from ActionController::ParameterMissing, with: :handle_missing_param
    rescue_from Pundit::NotAuthorizedError, with: :handle_unauthorized
  end

  private

  # Handle generic Ruby exceptions
  def handle_standard_error(e)
    Rails.logger.error("#{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
      if e.instance_of? AppError
        if Rails.env.development? || Rails.env.test?
          json_error(
            errors: e.backtrace.join("\n"),
            message: e.message,
            status: e.status
          )
        else
          json_error(
            message: e.message,
            status: e.status
          )
        end
      else
        if Rails.env.development? || Rails.env.test?
          json_error(
            errors: e.backtrace.join("\n"),
            message: I18n.t("errors.internal_server_error"),
            status: :internal_server_error
          )
        else
          json_error(
            message: I18n.t("errors.internal_server_error"),
            status: :internal_server_error
          )
        end
      end
  end

  # --- Handler for Missing Params (400) ---
  def handle_missing_param(e)
    # This happens when params.require(:user) fails
    Rails.logger.error("#{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    json_error(
      message: I18n.t("errors.missing_param", param: e.param),
      status: :bad_request
    )
  end


  # --- Handler for Pundit (403) ---
  def handle_unauthorized(e)
    Rails.logger.error("#{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    json_error(
      message: I18n.t("errors.unauthorized"),
      status: :unauthorized
    )
  end
end
