class Room < ApplicationRecord
  has_many :participants
  has_many :users,          through: :participants
  has_many :messages

  enum :room_type, { private: 0, group: 2 }
end
