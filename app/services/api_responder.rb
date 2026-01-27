# frozen_string_literal: true

module ApiResponder
  def json_success(data: nil, message: "success", status: :ok)
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

  def json_pagination(data: nil, meta: nil, message: "success", status: :ok)
    render json: {
      code: Rack::Utils.status_code(status),
      status: status,
      message: message,
      data: data,
      errors: nil,
      meta: meta
    }, status: status
  end
end
