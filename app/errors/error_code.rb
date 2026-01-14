# frozen_string_literal: true

module ErrorCode
  # Format: ERROR_NAME = { code: Int, message: String, status: Symbol }

  # Common Errors
  SYSTEM_ERROR = { code: 500, message: "errors.internal_server_error", status: :internal_server_error }
  SYSTEM_ERROR_DEBUG = { code: 500, message: "errors.internal_server_error_debug", status: :internal_server_error }
  BAD_REQUEST = { code: 400, message: "errors.bad_request", status: :bad_request }

  # Auth Errors
  UNAUTHORIZED = { code: 401, message: "errors.unauthorized", status: :unauthorized }
  TOKEN_EXPIRED = { code: 401, message: "errors.token_expired", status: :unauthorized }

end
