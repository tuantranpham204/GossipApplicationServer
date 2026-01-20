# frozen_string_literal: true

class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  ROLES = {
    USER: 1,
    ADMIN: 2
  }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_one :profile, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :profile

  has_many :messages, foreign_key: :sender_id, dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :rooms, through: :participants

  has_many :sent_requests, class_name: "Request", foreign_key: :sender_id, dependent: :destroy
  has_many :received_requests, class_name: "Request", foreign_key: :receiver_id, dependent: :destroy

  has_many :notifications_received, class_name: "Notification", foreign_key: :recipient_id, dependent: :destroy
  has_many :notifications_sent, class_name: "Notification", foreign_key: :actor_id, dependent: :destroy

  has_many :active_relationships, class_name: "UserRelation", foreign_key: :requester_id, dependent: :destroy
  has_many :passive_relationships, class_name: "UserRelation", foreign_key: :receiver_id, dependent: :destroy

  has_many :requesters, through: :passive_relationships, source: :requester
  has_many :receivers, through: :active_relationships, source: :receiver

  # Virtual attribute for authenticating by either username or email
  attr_writer :email_or_username

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP || VALID_EMAIL_REGEX },
            length: { maximum: 105 }

  # Add validations to ensure usernames are unique
  validates :username, presence: true, uniqueness: { case_sensitive: false }


  def roles_attributes=(role_attributes)
    role_attributes.each do |i, attributes|
      # If a role with this name exists, use it; otherwise build a new one
      id = attributes[:role_id]
      role = Role.find(id: id)
      if role
        self.roles << role unless self.roles.include?(role)
      else
        raise AppError.new(ErrorCode::RESOURCE_NOT_FOUND, params: { resource: { name: "role", attribute: "id" , value: id.to_s } })
      end
    end
  end

  def email_or_username
    @email_or_username || self.username || self.email
  end

  # Overwrite the Devise lookup method
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:email_or_username))
      # Query the DB for email OR username (case-insensitive)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end


end
