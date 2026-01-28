class AvatarUploadJob < ApplicationJob
  queue_as :default

  def perform(user_id, raw_avatar_data)
    begin
      profile = Profile.find_by(user_id: user_id)
      avatar_data_cache = profile.avatar_data
      begin
        new_avatar_data = Cloudinary::Uploader.upload(raw_avatar_data, folder: "profiles")
      rescue => e
        raise AppError.new(ErrorCode::MEDIA_UPLOAD_FAILED, params: { error: e.message })
      end

      profile.update!(avatar_data: {
        public_id: new_avatar_data["public_id"],
        url: new_avatar_data["secure_url"]
      })
      begin
        if avatar_data_cache && avatar_data_cache["public_id"]
          Cloudinary::Api.delete_resources(avatar_data_cache["public_id"])
        end
      rescue => e
        raise AppError.new(ErrorCode::MEDIA_DELETE_FAILED, params: { error: e.message })
      end
    rescue ActiveRecord::RecordNotFound
      raise AppError.new(ErrorCode::RESOURCE_NOT_FOUND, params: { resource_name: "Profile", resource_attribute: "user id", resource_value: params[:user_id] })
    rescue => e
      profile.update!(avatar_data: avatar_data_cache)
      raise AppError.new(ErrorCode::INTERNAL_SERVER_ERROR, params: { error: e.message })
    end
  end
end
