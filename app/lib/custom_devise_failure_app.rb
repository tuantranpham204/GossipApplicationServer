# app/lib/custom_devise_failure_app.rb
class CustomDeviseFailureApp < Devise::FailureApp
  def respond
    if request.format == :json
      json_error_response
    else
      super
    end
  end

  def json_error_response
    include ApiResponder
    self.status = 401
    self.content_type = 'application/json'

    # We manually construct the JSON to match your ApiResponder format
    # i18n_message handles the translation (e.g. "You need to sign in...")
    self.response_body = {
      code: 401,
      status: 'error',
      message: i18n_message,
      data: nil,
      errors: nil
    }.to_json
  end
end