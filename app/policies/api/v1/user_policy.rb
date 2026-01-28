# frozen_string_literal: true

module Api
  module V1
    class UserPolicy < ApplicationPolicy
      def update_me?
        true
      end
    end
  end
end
