class Participant < ApplicationRecord
  belongs_to :user
  belongs_to :room

  enum :role, { pending_approval: 0, host: 1, member: 2 }

end
