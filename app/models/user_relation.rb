class UserRelation < ApplicationRecord
  belongs_to :requester
  belongs_to :receiver

  enum :relation_type, { friend: 1, follow: 2 }
end
