class Admin::TasksController < Admin::BaseController
  def index
    @tasks = Task.includes(:creator, :assignee, sub_tasks: :assignee)

    @all_todo_tasks = @tasks.select { |t| t.status == "未着手" }
    @all_doing_tasks = @tasks.select { |t| t.status == "進行中" }
    @all_done_tasks = @tasks.select { |t| t.status == "完了" }
  end
end
