class Notification < ApplicationRecord
  belongs_to :recipient
  belongs_to :actor

  enum :notifable_type, { new_message: 1, friend_request: 2, room_join_request: 3, follow_request: 4 }
end
