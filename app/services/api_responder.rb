# frozen_string_literal: true

module ApiResponder

  def json_success(data: nil, message: "Success", status: :ok)
    render json: {
      code: Rack::Utils.status_code(status),
      status: status,
      message: message,
      data: data,
      errors: nil
    }, status: status
  end

  def json_error(message: "Error", status: :bad_request, errors: nil)
    render json: {
      code: Rack::Utils.status_code(status),
      status: status,
      message: message,
      data: nil,
      errors: errors
    }, status: status
  end

end
