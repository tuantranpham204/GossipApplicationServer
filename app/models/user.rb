class User < ApplicationRecord
  has_one :profile,                  dependent: :destroy
  has_many :participants
  has_many :rooms,                        through: :participants
  has_many :messages,                     foreign_key: :sender_id
  has_many :sent_requests,                class_name: "Request", foreign_key: :sender_id
  has_many :received_requests,            class_name: "Request", foreign_key: :receiver_id
  has_many :notifications,                foreign_key: :recipient_id
  has_many :sent_notifications,           class_name: "Notification", foreign_key: :actor_id
  has_many :user_relations_as_requester,  class_name: "UserRelation", foreign_key: :requester_id
  has_many :user_relations_as_receiver,   class_name: "UserRelation", foreign_key: :receiver_id
  has_and_belongs_to_many :roles,   join_table: "user_role"


  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Devise Modules
  # :validatable handles basic Email (presence, format, uniqueness)
  # and Password (presence, length 6-128).
  devise :database_authenticatable, :registerable,
         :validatable, :jwt_authenticatable,
         jwt_revocation_strategy: self

  validates :email, format: {
    with: URI::MailTo::EMAIL_REGEXP || "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    message: I18n.t("validation.invalid_email")
  }

  # Strict Password Complexity (The "Real World" Check)
  # Ensure password has 1 uppercase, 1 lowercase, 1 number
  validate :password_complexity

  # 5. JTI Safety
  validates :jti, presence: true

  # 6. Callbacks
  before_create :generate_jti
  before_save :downcase_email


  def admin?
    roles.exists?(name: "ADMIN")
  end

  private

  def generate_jti
    self.jti ||= SecureRandom.uuid
  end

  def downcase_email
    self.email = email.downcase
  end

  def password_complexity
    # Only run this check if the password is actually changing
    return if password.blank? || password =~ /(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])/

    errors.add :password, I18n.t("validation.password_complexity")
  end
end
