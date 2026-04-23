class Admin::TasksController < Admin::BaseController
  def index
    @tasks = Task.includes(:creator, :assignee, sub_tasks: :assignee)
                 .order(due_date: :asc)

    @staffs = User.all

    if params[:user_id].present?
      @tasks = @tasks.where(assignee_id: params[:user_id])
    end

    @overdue_tasks = @tasks.select { |t| t.overdue? }
    @urgent_tasks  = @tasks.select { |t| t.urgent? }

    @tasks = case params[:filter]
    when "overdue" then @overdue_tasks
    when "urgent"  then @urgent_tasks
    else @tasks
    end


    @all_todo_tasks = @tasks.select { |t| t.status == "未着手" }
    @all_doing_tasks = @tasks.select { |t| t.status == "進行中" }
    @all_done_tasks = @tasks.select { |t| t.status == "完了" }
  end
end
