admin = User.find_or_create_by!(email: "admin1@gmail.com") do |user|
  user.password = "password01"
  user.name = "管理者一郎"
  user.admin = true
end

guest_user = User.find_or_create_by!(email: "guest@example.com") do |user|
  user.password = SecureRandom.urlsafe_base64
  user.name = "ゲストユーザー"
  user.guest = true
end

suzuki = User.find_or_create_by!(email: "saburo@gmail.com") do |user|
  user.password = "password03"
  user.name = "鈴木三郎"
end

puts "既存のタスクデータをリセット中"
SubTask.destroy_all
Task.destroy_all

def random_due_date(status)
  case status
  when "完了"
    Date.today - rand(1..5).days
  when "進行中"
    Date.today + rand(-1..3).days
  else
    Date.today + rand(1..7).days
  end
end

def random_assigned_date
  Date.today - rand(1..10).days
end

def force_save_task(attrs)
  t = Task.new(attrs)
  t.save(validate: false)
  t
end

def force_save_sub_task(attrs)
  s = SubTask.new(attrs)
  s.save(validate: false)
  s
end

puts "訪問看護のカルテチェックに基づいたデータを作成中（バリデーション回避）"

# --- 親タスク (Task1 ~ Task8) ---
task1 = force_save_task({
    title: "利用者Aさんのカルテチェック",
    status: "未着手",
    priority: "中",
    estimated_minutes: 15,
    due_date: random_due_date("未着手"),
    assigned_date: random_assigned_date,
    user_id: admin.id,
    assignee_id: guest_user.id
})

task2 = force_save_task({
    title: "利用者Bさんのカルテチェック",
    status: "未着手",
    priority: "低",
    estimated_minutes: 20,
    due_date: random_due_date("未着手"),
    assigned_date: random_assigned_date,
    user_id: admin.id,
    assignee_id: guest_user.id
})

task3 = force_save_task({
    title: "利用者Cさんのカルテチェック",
    status: "未着手",
    priority: "中",
    estimated_minutes: 20,
    due_date: random_due_date("未着手"),
    assigned_date: random_assigned_date,
    user_id: admin.id,
    assignee_id: guest_user.id
})

task4 = force_save_task({
    title: "利用者Dさんのカルテチェック",
    status: "進行中",
    priority: "高",
    estimated_minutes: 10,
    due_date: random_due_date("進行中"),
    assigned_date: random_assigned_date,
    user_id: admin.id,
    assignee_id: guest_user.id
})

task5 = force_save_task({
    title: "利用者Dさんのカルテチェック",
    status: "進行中",
    priority: "中",
    estimated_minutes: 15,
    due_date: random_due_date("進行中"),
    assigned_date: random_assigned_date,
    user_id: admin.id,
    assignee_id: guest_user.id
})

task6 = force_save_task({
    title: "利用者Eさんのカルテチェック",
    status: "完了",
    priority: "高",
    estimated_minutes: 15,
    due_date: random_due_date("完了"),
    assigned_date: random_assigned_date,
    user_id: admin.id,
    assignee_id: guest_user.id
})

task7 = force_save_task({
    title: "利用者Fさんのカルテチェック",
    status: "進行中",
    priority: "高",
    estimated_minutes: 15,
    due_date: random_due_date("進行中"),
    assigned_date: random_assigned_date,
    user_id: admin.id,
    assignee_id: suzuki.id
})

task8 = force_save_task({
    title: "利用者Gさんのカルテチェック",
    status: "進行中",
    priority: "低",
    estimated_minutes: 10,
    due_date: random_due_date("進行中"),
    assigned_date: random_assigned_date,
    user_id: admin.id,
    assignee_id: suzuki.id
})

# --- 子タスク (SubTask) ---
force_save_sub_task({
  task_id: task5.id,
  user_id: guest_user.id,
  assignee_id: suzuki.id,
  title: "2026年4月分の計画書のサインをもらう",
  status: "未着手",
  priority: "高",
  due_date: random_due_date("未着手"),
  estimated_minutes: 5
})

force_save_sub_task({
  task_id: task5.id,
  user_id: guest_user.id,
  assignee_id: suzuki.id,
  title: "2026年3月のケアプランをもらう",
  status: "完了",
  priority: "高",
  due_date: random_due_date("完了"),
  estimated_minutes: 5,
  note: "ケアマネさんに電話お願いします"
})

force_save_sub_task({
  task_id: task7.id,
  user_id: suzuki.id,
  assignee_id: guest_user.id,
  title: "2026年1月計画書をもらう",
  status: "未着手",
  priority: "高",
  due_date: random_due_date("未着手"),
  estimated_minutes: 5,
  note: "2026年1月計画書のサインの日付が間違っていたため、もう一度サインをもらってください"
})

force_save_sub_task({
  task_id: task8.id,
  user_id: suzuki.id,
  assignee_id: guest_user.id,
  title: "2026年1月からのケアプラン",
  status: "未着手",
  priority: "高",
  due_date: random_due_date("未着手"),
  estimated_minutes: 5,
  note: "2026年1月からのケアプランが見当たらないので、ケアマネさんに確認をお願いします"
})

puts "完了！すべてのタスクとサブタスクが正常に入れ替えられました"
