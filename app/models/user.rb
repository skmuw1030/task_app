class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :created_tasks, class_name: "Task", foreign_key: "user_id", dependent: :destroy
  has_many :assigned_tasks, class_name: "Task", foreign_key: "assignee_id"
  has_many :sub_tasks, through: :created_tasks

  validates :name, presence: true
end
