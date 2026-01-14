class Room < ApplicationRecord
  enum :room_type, { private: 0, group: 2 }
end
