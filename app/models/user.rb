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
         :confirmable,
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
  
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP || VALID_EMAIL_REGEX },
            length: { maximum: 105 }

  # Add validations to ensure usernames are unique
  validates :username, presence: true, uniqueness: { case_sensitive: false }


end
