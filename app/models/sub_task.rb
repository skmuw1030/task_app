class SubTask < ApplicationRecord
  belongs_to :task

  belongs_to :creator, class_name: "User", foreign_key: "user_id"

  belongs_to :assignee, class_name: "User", foreign_key: "assignee_id", optional: true

  validates :title, presence: true, length: { maximum: 30 }
  validates :status, presence: true, inclusion: { in: Task::STATUSES }
  validates :priority, presence: true, inclusion: { in: Task::PRIORITIES }
  validate :due_date_today_or_future
  validate :due_date_task_after_sub_task
  validates :estimated_minutes,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 },
            allow_nil: true
  validate :estimated_minutes_step_five
  validates :note, length: { maximum: 300 }

  before_save :record_completed_at

  def update_with_timestamps(new_status)
    self.status = new_status

    case new_status
    when "進行中"
      self.started_at ||= Date.today
    when "完了"
      self.completed_at ||= Date.today
    end

    save!
  end

  def due_status
    return :none unless due_date
    return :done if status == "完了"

    case
    when due_date < Date.today
      :overdue
    when due_date <= Date.today + Task::URGENT_DAYS.days
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

  def fit_in_time?(minutes)
    return false if minutes.nil?
    return false if estimated_minutes.nil?

    estimated_minutes <= minutes.to_i
  end

  def sub_tasks
    SubTask.none
  end

  def completable?
    true
  end


  private

  def due_date_today_or_future
    return if due_date.blank?

    if due_date < Date.today
      errors.add(:due_date, "は本日以降の日付にしてください")
    end
  end

  def due_date_task_after_sub_task
    return if due_date.blank? || task.due_date.blank?

    if due_date > task.due_date
      errors.add(:due_date, "は親タスクの期限(#{task.due_date.strftime("%m/%d")})以前に設定してください")
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
  end

  def estimated_minutes_step_five
    if estimated_minutes.present? && estimated_minutes % 5 != 0
      errors.add(:estimated_minutes, "は5分単位で入力してください")
    end
  end
end
