class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :duration, numericality: { in: 0.5..24 }
end
