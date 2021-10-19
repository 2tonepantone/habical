class Schedule < ApplicationRecord
  belongs_to :user
  has_many :busy_blocks
end
