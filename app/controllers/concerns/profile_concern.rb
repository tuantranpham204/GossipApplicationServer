# frozen_string_literal: true

module ProfileConcern
  extend ActiveSupport::Concern
  include ErrorCode
  include ErrorHandlers

  def create_profile(params = {})
    begin
      Profile.create(user_id: params[:user_id],
                     gender: params[:gender],
                     relationship_status: params[:relationship_status],
                     full_name: params[:full_name],
                     status: params[:status])
    rescue => e
      raise AppError.new(ErrorCode::VALIDATION_ERROR, params: { details: e.message })
    end
  end
end
