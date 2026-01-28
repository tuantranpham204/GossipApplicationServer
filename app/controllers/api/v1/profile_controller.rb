# frozen_string_literal: true

module Api
  module V1
    class ProfileController < ApplicationController
      def search
        begin
          query = params[:q].presence || "*"
          @profiles = Profile.search(
            query,
            # Define which fields to search
            fields: [
              "username^10", # ^10 means matches on username are 10x more important
              "full_name",   # Matches "John Doe"
              "first_name",
              "last_name",
              "reversed_full_name"
            ],
            match: :word_start, # Enables partial matching ("joh" matches "john")
            misspellings: { edit_distance: 1 }, # Optional: Handles typos ("Jhon")
            page: params[:page],
            per_page: params[:per_page]
          )
          authorize @profiles, :search?, policy_class: Api::V1::ProfilePolicy
        rescue Pundit::NotAuthorizedError
          raise AppError.new(ErrorCode::USER_UNPERMITTED)
        end
        json_pagination(
          data:
            @profiles.map do |profile|
                {
                    user_id: profile.user_id,
                    username: profile.user.username,
                    email: profile.is_email_public ? profile.user.email : nil,
                    first_name: profile.first_name,
                    last_name: profile.last_name,
                    bio: profile.bio,
                    dob: profile.dob,
                    gender:  profile.is_gender_public ? profile.gender : nil,
                    relationship_status: profile.is_rel_status_public ? profile.relationship_status : nil,
                    status: profile.is_email_public ? profile.status : nil,
                    avatar_data: {
                      url: profile.avatar_data["url"]
                    },
                    is_email_public: profile.is_email_public,
                    is_gender_public: profile.is_gender_public,
                    is_rel_status_public: profile.is_rel_status_public
                  }
            end,
          meta: {
            total_pages: @profiles.total_pages,
            total_count: @profiles.total_count,
            current_page: @profiles.current_page,
            per_page: @profiles.per_page
          })
      end


      # GET /profiles/avatar/:user_id
      def get_avatar
        begin
          @profile = Profile.find_by!(user_id: params[:user_id])
          authorize @profile, :get_avatar?, policy_class: Api::V1::ProfilePolicy
        rescue Pundit::NotAuthorizedError
          raise AppError.new(ErrorCode::USER_UNPERMITTED)
        rescue ActiveRecord::RecordNotFound
          raise AppError.new(ErrorCode::RESOURCE_NOT_FOUND, params: { resource: { name: "Profile", attribute: "user id", id: params[:user_id] } })
        end
        json_success(data: @profile.avatar_data)
      end

      # GET /profiles/host/:user_id
      def get_by_host
        begin
          @profile = Profile.find_by!(user_id: params[:user_id])
          authorize @profile, :get_by_host?, policy_class: Api::V1::ProfilePolicy
          friends_amt = UserRelation.get_friends_amount(params[:user_id])
          followers_amt = UserRelation.get_followers_amount(params[:user_id])
          following_amt = UserRelation.get_following_amount(params[:user_id])
        rescue Pundit::NotAuthorizedError
          raise AppError.new(ErrorCode::USER_UNPERMITTED)
        rescue ActiveRecord::RecordNotFound
          raise AppError.new(ErrorCode::RESOURCE_NOT_FOUND, params: { resource: { name: "Profile", attribute: "user id", id: params[:user_id] } })
        end
        profile_hash = @profile.as_json.except(:user_id)
        json_success(data: { username: current_user.username,
                              email: current_user.email,
                              friends_amt: friends_amt,
                              followers_amt: followers_amt,
                              following_amt: following_amt,
                              **profile_hash })
      end

      # GET /profiles/guest/:user_id
      def get_by_guest
        begin
          @profile = Profile.find_by!(user_id: params[:user_id])
          authorize @profile, :get_by_guest?, policy_class: Api::V1::ProfilePolicy

          # TODO: add these fields to profile table.
          friends_amt = UserRelation.get_friends_amount(params[:user_id])
          followers_amt = UserRelation.get_followers_amount(params[:user_id])
          following_amt = UserRelation.get_following_amount(params[:user_id])
        rescue Pundit::NotAuthorizedError
          raise AppError.new(ErrorCode::USER_UNPERMITTED)
        rescue ActiveRecord::RecordNotFound
          raise AppError.new(ErrorCode::RESOURCE_NOT_FOUND, params: { resource: { name: "Profile", attribute: "user id", id: params[:user_id] } })
        end
        json_success(data: {
          user_id: @profile.user_id,
          friends_amt: friends_amt,
          followers_amt: followers_amt,
          following_amt: following_amt,
          username: @profile.user.username,
          email: @profile.is_email_public ? @profile.user.email : nil,
          first_name: @profile.first_name,
          last_name: @profile.last_name,
          bio: @profile.bio,
          dob: @profile.dob,
          gender:  @profile.is_gender_public ? @profile.gender : nil,
          relationship_status: @profile.is_rel_status_public ? @profile.relationship_status : nil,
          status: @profile.is_email_public ? @profile.status : nil,
          avatar_data: {
            url: @profile.avatar_data["url"]
          },
          is_email_public: @profile.is_email_public,
          is_gender_public: @profile.is_gender_public,
          is_rel_status_public: @profile.is_rel_status_public
        })
      end

      # PATCH /profiles/:user_id
      def update
        begin
          @profile = Profile.find_by!(user_id: params[:user_id])
          authorize @profile, :update?, policy_class: Api::V1::ProfilePolicy
          permitted_params = params.permit(
            :first_name, :last_name, :bio, :dob, :gender, :relationship_status, :status,
            :allow_direct_follows, :is_gender_public, :is_email_public, :is_rel_status_public
          )
          @profile.update!(permitted_params)
        rescue Pundit::NotAuthorizedError
          raise AppError.new(ErrorCode::USER_UNPERMITTED)
        rescue ActiveRecord::RecordNotFound
          raise AppError.new(ErrorCode::RESOURCE_NOT_FOUND, params: { resource: { name: "Profile", attribute: "user id", id: params[:user_id] } })
        end
        json_success(message: I18n.t("messages.profile_updated"))
      end

      # PATCH /profiles/avatar/:user_id
      def update_avatar
        begin
          @profile = Profile.find_by!(user_id: params[:user_id])
          raw_avatar_data = params[:raw_avatar_data]


          if raw_avatar_data.nil?
            raise AppError.new(ErrorCode::MISSING_PARAMETERS, params: { details: "Missing avatar image" })
          end


          authorize @profile, :update_avatar?, policy_class: Api::V1::ProfilePolicy

          # Convert uploaded file to Base64 to pass to Sidekiq
          if raw_avatar_data.respond_to?(:read)
            encoded_image = Base64.strict_encode64(raw_avatar_data.read)
            data_uri = "data:#{raw_avatar_data.content_type};base64,#{encoded_image}"
            AvatarUploadJob.perform_later(@profile.user_id, data_uri)
          else
            AvatarUploadJob.perform_later(@profile.user_id, raw_avatar_data)
          end
        rescue Pundit::NotAuthorizedError
          raise AppError.new(ErrorCode::USER_UNPERMITTED)
        end
        json_success(message: "Avatar upload queued")
      end
    end
  end
end
