# frozen_string_literal: true

module Api
  module V1
    class ProfilePolicy < ApplicationPolicy
      def get_by_host?
        user&.id == record.user_id && user&.roles.include?(User::ROLES[:USER])
      end

      def get_by_guest?
        user&.id != record.user_id && user&.roles.include?(User::ROLES[:USER])
      end

      def update?
        user&.id == record.user_id && user&.roles.include?(User::ROLES[:USER])
      end

      def update_avatar?
        user&.id == record.user_id && user&.roles.include?(User::ROLES[:USER])
      end

      def get_avatar?
        user&.id == record.user_id && user&.roles.include?(User::ROLES[:USER])
      end
    end
  end
end
