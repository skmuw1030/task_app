class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :created_tasks, class_name: "Task", foreign_key: "user_id", dependent: :destroy
  has_many :assigned_tasks, class_name: "Task", foreign_key: "assignee_id", dependent: :nullify
  has_many :sub_tasks, through: :created_tasks
  has_many :created_sub_tasks, class_name: "SubTask", foreign_key: "user_id", dependent: :destroy
  has_many :assigned_sub_tasks, class_name: "SubTask", foreign_key: "assignee_id", dependent: :nullify


  validates :name, presence: true
  validates :password, format: {
    with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i,
    message: "は英字と数字の両方を含めて8文字以上で設定してください"
  }, if: :password_required?

  def self.guest
    find_or_create_by!(email: "guest@example.com") do | user |
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
      user.guest = true
    end
  end

  def guest?
    guest
  end

  private

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end
