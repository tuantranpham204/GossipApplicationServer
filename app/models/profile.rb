class Profile < ApplicationRecord
  VALID_NAME_REGEX = /\A[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžæœÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ ,.'-]+\z/


  belongs_to :user

  enum :gender, { male: 1, female: 0 }
  enum :relationship_status, { single: 0, in_a_relationship: 1, married: 2 }
  enum :status, { inactive: 0, active: 1, banned: 3 }

  validates :first_name, presence: true, length: { minimum: 1, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 1, maximum: 50 }
  validates :first_name, :last_name, format: { with: VALID_NAME_REGEX }, if: -> { Rails.env.production? }


  searchkick word_start: [ :username, :first_name, :last_name, :full_name, :reversed_full_name ]

  def search_data
    {
      username: user.username,
      first_name: first_name,
      last_name: last_name,
      full_name: "#{first_name} #{last_name}".strip,
      reversed_full_name: "#{last_name} #{first_name}".strip
    }
  end
end
