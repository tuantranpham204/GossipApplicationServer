class Users::RegistrationsController < Devise::RegistrationsController
  include ApiResponder
  include ErrorHandlers
  include ProfileConcern
  include JwtService
  # before_action :sign_up_params


  # POST /resource
  def create
    build_resource sign_up_params
    resource.save
    if resource.persisted?
      if resource.active_for_authentication?
        sign_up(resource_name, resource)
        json_success(data: { user: resource, profile: resource.profile })
      else
        expire_data_after_sign_in!
        raise AppError.new(ErrorCode::UNAUTHORIZED)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      raise AppError.new(ErrorCode::VALIDATION_ERROR, params: { details: resource.errors.full_messages.to_s })
    end
  end


  protected

  def sign_up_params
    {
      email: params[:user][:email],
      password: params[:user][:password],
      password_confirmation: params[:user][:password_confirmation],
      username: params[:user][:username],
      profile_attributes: {
        first_name: params[:user][:first_name],
        last_name: params[:user][:last_name],
        gender: params[:user][:gender],
      }
    }
  end
end