class Profile < ApplicationRecord
  belongs_to :user

  enum :gender, { male: 0, female: 1 }
  enum :relationship_status, { single: 0, in_a_relationship: 1, married: 2 }
  enum :status, { inactive: 0, active: 1, banned: 3 }

  validates :first_name, presence: true
  validates :last_name, presence: true


end
