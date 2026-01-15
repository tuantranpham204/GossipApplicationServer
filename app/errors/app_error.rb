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
end