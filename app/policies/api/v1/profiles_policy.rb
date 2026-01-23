# frozen_string_literal: true

module Api
  module V1
    class ProfilesPolicy < ApplicationPolicy
      def get_by_host?
        user&.id == params[:user_id]
      end

      def get_by_guest?
        user&.id != params[:user_id]
      end
    end
  end
end
