# frozen_string_literal: true

class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_USERNAME_REGEX = /\A(?![._-])(?!.*[._-]{2})[a-zA-Z0-9._-]+(?<![._-])\z/
  VALID_PASSWORD_REGEX = /\A(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\S+$).{8,20}\z/

  ROLES = {
    USER: 1,
    ADMIN: 2
  }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable,
         :jwt_authenticatable,
         # :omniauthable,
         jwt_revocation_strategy: JwtDenylist
  # omniauth_providers: [:google_oauth2]


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
  validates :username, presence: true, length: { minimum: 5, maximum: 30 }, uniqueness: { case_sensitive: false }, format: { with: VALID_USERNAME_REGEX }
  validates :password, presence: true,
                       length: Rails.env.production? ? { minimum: 0, maximum: 20 } : { minimum: 6, maximum: 20 }
  validates :password, format: { with: VALID_PASSWORD_REGEX }, if: -> { Rails.env.production? }


  # Override Devise's method to send emails asynchronously
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end



  # def self.from_omniauth(auth)
  #   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  #     user.email = auth.info.email
  #     user.password = Devise.friendly_token[0, 20]
  #     user.password_confirmation = user.password
  #     user.username = auth.info.email.split("@").first + "_" + SecureRandom.hex(4)
  #     user.confirmed_at = Time.current
  #     user.profile_attributes = {
  #       first_name: auth.info.first_name || "First",
  #       last_name: auth.info.last_name || "Last",
  #       gender: 1,
  #       dob: Date.new(2000, 1, 1)
  #     }
  #   end
  # end
end
