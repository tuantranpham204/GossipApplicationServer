class AppError < StandardError
  attr_reader :code, :status, :message, :errors

  # usage: raise AppError.new(ErrorCode::USER_NOT_FOUND)
  # usage: raise AppError.new(ErrorCode::INVALID_TICKET, params: { ticket_id: ticket.id  })
  attr_reader :code, :status, :message, :errors

  def initialize(error_type, params: {}, errors: nil, message: nil)
    @code = error_type[:code]
    @status = error_type[:status]
    @errors = errors

    # Logic:
    # 1. Get the key from the constant (e.g., 'errors.bad_request')
    key_or_text = message || error_type[:message]

    # 2. Perform the translation NOW using the current request's locale.
    #    If the key doesn't exist in yml, it falls back to printing the key (or handling missing trans).
    @message = I18n.t(key_or_text, **params)
  end

  private
  def handle_standard_error(e)
    # 1. Decide which Error Code to use based on Environment
    error_type = if Rails.env.development? || Rails.env.test?
                   ErrorCode::SYSTEM_ERROR_DEBUG # Uses %{details}
                 else
                   ErrorCode::SYSTEM_ERROR       # Generic "Internal Error"
                 end

    # 2. Raise it (or render directly)
    # We pass e.message safely into params.
    # If the 'error_type' doesn't use %{details}, the extra param is just ignored safely.
    json_error(
      message: I18n.t(error_type[:message], details: e.message),
      status: :internal_server_error
    )
  end

end