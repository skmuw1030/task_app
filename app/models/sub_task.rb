class SubTask < ApplicationRecord
  belongs_to :task

  belongs_to :creator, class_name: "User", foreign_key: "user_id"

  belongs_to :assignee, class_name: "User", foreign_key: "assignee_id", optional: true

  validates :title, presence: true, length: { maximum: 50 }
  validates :status, presence: true, inclusion: { in: Task::STATUSES }
  validates :priority, presence: true, inclusion: { in: Task::PRIORITIES }
  validates :estimated_minutes,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 },
            allow_nil: true
end
