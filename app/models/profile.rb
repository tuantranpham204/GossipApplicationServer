class Profile < ApplicationRecord
  belongs_to :user

  enum :gender, { male: 1, female: 0 }
  enum :relationship_status, { single: 0, in_a_relationship: 1, married: 2 }
  enum :status, { inactive: 0, active: 1, banned: 3 }

end
