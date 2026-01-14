class User < ApplicationRecord
  has_one :profile
  has_many :participants
  has_many :rooms,                        through: :participants
  has_many :messages,                     foreign_key: :sender_id
  has_many :sent_requests,                class_name: "Request", foreign_key: :sender_id
  has_many :received_requests,            class_name: "Request", foreign_key: :receiver_id
  has_many :notifications,                foreign_key: :recipient_id
  has_many :sent_notifications,           class_name: "Notification", foreign_key: :actor_id
  has_many :user_relations_as_requester,  class_name: "UserRelation", foreign_key: :requester_id
  has_many :user_relations_as_receiver,   class_name: "UserRelation", foreign_key: :receiver_id
  has_and_belongs_to_many :roles, join_table: "user_role"
end
