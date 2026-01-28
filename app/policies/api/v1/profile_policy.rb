# frozen_string_literal: true

module Api
  module V1
    class ProfilePolicy < ApplicationPolicy
      def get_by_host?
        user && user&.id == record.user_id && user&.roles.include?(User::ROLES[:USER])
      end

      def get_by_guest?
        user && user&.id != record.user_id && user&.roles.include?(User::ROLES[:USER])
      end

      def update?
        user && user&.id == record.user_id && user&.roles.include?(User::ROLES[:USER])
      end

      def update_avatar?
        user && user&.id == record.user_id && user&.roles.include?(User::ROLES[:USER])
      end

      def get_avatar?
        user && user&.roles.include?(User::ROLES[:USER])
      end

      def search?
        user && user&.roles.include?(User::ROLES[:USER])
      end
    end
  end
end
