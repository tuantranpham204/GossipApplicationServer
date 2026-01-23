# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < ApplicationController
      # GET /profiles/host/:user_id
      def get_by_host
        authorize [ :api, :v1, :profiles ], :get_by_host?
        begin
          @profile_response = Profile.find_by(user_id: params[:user_id])
        rescue => e
          raise AppError.new(ErrorCode::RESOURCE_NOT_FOUND, params: { resource: { name: "Profile", attribute: "user id", id: params[:user_id] } })
        end
        json_success(data: @profile_response)
      end

      # GET /profiles/guest/:user_id
      def get_by_guest
        authorize [ :api, :v1, :profiles ], :get_by_guest?
        begin
          @profile_response = Profile.find_by(user_id: params[:user_id])
        rescue => e
          raise AppError.new(ErrorCode::RESOURCE_NOT_FOUND, params: { resource: { name: "Profile", attribute: "user id", id: params[:user_id] } })
        end
        json_success(data: @profile_response)
      end
    end
  end
end
