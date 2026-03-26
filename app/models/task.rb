class Task < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: "user_id"

  belongs_to :assignee, class_name: "User", foreign_key: "assignee_id", optional: true

  has_many :sub_tasks, dependent: :destroy

  validates :title, presence: true
  validates :status, presence: true
  validates :priority, presence: true
end
