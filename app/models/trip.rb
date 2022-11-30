class Trip < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :side_quests, through: :stops
  has_many :stops, dependent: :destroy
  has_one :category, through: :side_quests
  belongs_to :start_location, class_name: 'Location', foreign_key: 'start_location_id'
  belongs_to :end_location, class_name: 'Location', foreign_key: 'end_location_id'
end
