class Task < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: "user_id"

  belongs_to :assignee, class_name: "User", foreign_key: "assignee_id", optional: true

  belongs_to :missing_doc_requested_user, class_name: "User", foreign_key: :missing_doc_requested_to, optional: true

  has_many :sub_tasks, dependent: :destroy

  STATUSES = [ "未着手", "進行中", "完了" ]
  PRIORITIES = [ "高", "中", "低" ]

  validates :title, presence: true, length: { maximum: 50 }
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :priority, presence: true, inclusion: { in: PRIORITIES }
  validates :estimated_minutes,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 },
            allow_nil: true
  validate :estimated_minutes_step_five
  validates :missing_doc_memo, length: { maximum: 500 }, presence: true, if: :has_missing_docs?
  validates :missing_doc_requested_to, length: { maximum: 5 }, allow_blank: true
  validates :comment, length: { maximum: 500 }

  after_initialize :set_default_values, if: :new_record?

  private

  def set_default_values
    self.status ||= "未着手"
    self.priority ||= "中"
    self.assigned_date ||= Date.today
  end

  def estimated_minutes_step_five
    if estimated_minutes.present? && estimated_minutes % 5 != 0
      errors.add(:estimated_minutes, "は５分単位で入力してください")
    end
  end
end
