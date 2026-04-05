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

  before_save :record_completed_at

  private

  def record_completed_at
    return unless status_changed?

    if status == "完了"
      self.completed_at = Date.today
    else
      self.completed_at = nil
    end
  end
end
