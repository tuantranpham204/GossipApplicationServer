class Request < ApplicationRecord
  belongs_to :sender,   class_name: "User"
  belongs_to :receiver, class_name: "User"

  enum :request_type, { friend: 1, room_join: 2, follow: 3 }
  enum :status, { pending: 0, accepted: 1, declined: 2 }
end
