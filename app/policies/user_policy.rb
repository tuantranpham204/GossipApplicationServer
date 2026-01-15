# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def update_me?
    true
  end
end

