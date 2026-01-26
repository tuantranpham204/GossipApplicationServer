# frozen_string_literal: true

module ErrorCode
  # Format: ERROR_NAME = { code: Int, message: String, status: Symbol }

  # Common Errors
  SYSTEM_ERROR = { code: 500, message: "errors.internal_server_error", status: :internal_server_error }
  SYSTEM_ERROR_DEBUG = { code: 500, message: "errors.internal_server_error_debug", status: :internal_server_error }
  BAD_REQUEST = { code: 400, message: "errors.bad_request", status: :bad_request }
  VALIDATION_ERROR = { code: 422, message: "validation.validation_error", status: :unprocessable_entity }

  # Auth Errors
  UNAUTHORIZED = { code: 401, message: "errors.unauthorized", status: :unauthorized }
  TOKEN_EXPIRED = { code: 401, message: "errors.token_expired", status: :unauthorized }
  USERNAME_USED = { code: 401, message: "validation.input_username_again", status: :unauthorized }
  SIGN_IN_FAILED = { code: 401, message: "validation.sign_in_failed", status: :unauthorized }

  # Forbidden Errors
  FORBIDDEN = { code: 403, message: "errors.forbidden", status: :forbidden }
  USER_UNPERMITTED = { code: 403, message: "errors.user_unpermitted", status: :forbidden }


  RESOURCE_NOT_FOUND = { code: 400, message: "errors.resource_not_found", status: :not_found }
  CANNOT_CREATE_RESOURCE = { code: 400, message: "errors.cannot_create_resource", status: :bad_request }
end
