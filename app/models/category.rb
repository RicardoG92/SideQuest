class Category < ApplicationRecord
  has_many :side_quests, dependent: :destroy
  validates :name, presence: true
end
