class UserRelation < ApplicationRecord
  belongs_to :requester,  class_name: "User"
  belongs_to :receiver,   class_name: "User"

  enum :relation_type, { friend: 1, follow: 2 }


  def self.get_friends_amount(user_id)
    UserRelation.where(requester_id: user_id, relation_type: :friend).count
  end

  def self.get_followers_amount(user_id)
    UserRelation.where(receiver_id: user_id, relation_type: :follow).count
  end

  def self.get_following_amount(user_id)
    UserRelation.where(requester_id: user_id, relation_type: :follow).count
  end
end
