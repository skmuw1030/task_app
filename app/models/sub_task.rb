class SubTask < ApplicationRecord
  belongs_to :task

  belongs_to :creator, class_name: "User", foreign_key: "user_id"

  belongs_to :assignee, class_name: "User", foreign_key: "assignee_id", optional: true
end
