# rubocop:disable Rails/HasManyOrHasOneDependent

class Category < ApplicationRecord
  has_many :shops

  validates :name, presence: true, uniqueness: true
end

# rubocop:enable Rails/HasManyOrHasOneDependent
