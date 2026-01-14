class Notification < ApplicationRecord
  belongs_to :recipient,  class_name: "User"
  belongs_to :actor,      class_name: "User"

  enum :notifiable_type, { new_message: 1, friend_request: 2, room_join_request: 3, follow_request: 4 }
end
