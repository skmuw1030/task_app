class Task < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: "user_id"

  belongs_to :assignee, class_name: "User", foreign_key: "assignee_id", optional: true

  # belongs_to :missing_doc_requested_user, class_name: "User", foreign_key: :missing_doc_requested_to, optional: true

  has_many :sub_tasks, dependent: :destroy

  STATUSES = [ "未着手", "進行中", "完了" ]
  PRIORITIES = [ "高", "中", "低" ]
  SUKIMA_TIMES = [ 5, 10, 15, 30, 60 ].freeze
  URGENT_DAYS = 3

  validates :title, presence: true, length: { maximum: 50 }
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :priority, presence: true, inclusion: { in: PRIORITIES }
  validate :due_date_today_or_future
  validates :estimated_minutes,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 },
            allow_nil: true
  validate :estimated_minutes_step_five
  # validates :missing_doc_memo, length: { maximum: 500 }, presence: true, if: :has_missing_docs?
  # validates :missing_doc_requested_to, length: { maximum: 5 }, allow_blank: true
  validates :comment, length: { maximum: 500 }

  after_initialize :set_default_values, if: :new_record?

  before_save :record_completed_at

  def update_with_timestamps(new_status)
    self.status = new_status

    case new_status
    when "進行中"
      self.started_at ||= Date.today
    when "完了"
      self.completed_at ||= Date.today
    end

    save
  end


  def due_status
    return :none unless due_date
    return :done if status == "完了"

    case
    when due_date < Date.today
      :overdue
    when due_date <= Date.today + URGENT_DAYS.days
      :urgent
    else
      :normal
    end
  end

  def overdue?
    due_status == :overdue
  end

  def urgent?
    due_status == :urgent
  end

  def days_left
    return nil unless due_date
    (due_date - Date.today).to_i
  end

  def completable?
    sub_tasks.all? do |st|
      st.status == "完了"
    end
  end

  def done_sub_tasks_count
    sub_tasks.where(status: "完了").count
  end

  def total_sub_tasks_count
    sub_tasks.count
  end

  def sub_tasks_progress
    return 0 if sub_tasks.empty?

    ((done_sub_tasks_count.to_f / total_sub_tasks_count) * 100).round
  end

  def sub_tasks_progress_view
    "#{done_sub_tasks_count} / #{total_sub_tasks_count} 完了"
  end



  def fit_in_time?(minutes)
    return false if minutes.nil?
    return false if estimated_minutes.nil?

    estimated_minutes <= minutes.to_i
  end



  private

  def due_date_today_or_future
    return if due_date.blank?

    if due_date < Date.today
      errors.add(:due_date, "は本日以降の日付にしてください")
    end
  end

  def record_completed_at
    return unless status_changed?

    if status == "完了"
      self.completed_at = Date.today
    else
      self.completed_at = nil
    end
  end

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
