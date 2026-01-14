class Message < ApplicationRecord
  belongs_to :room
  belongs_to :sender

  # ordinary messages are messages between general users
  enum :message_type, { ordinary_text: 1, ordinary_media: 2, system: 3 }


end
