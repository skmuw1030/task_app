class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [ :edit, :update, :destroy ]

  def index
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.created_tasks.build(task_params)
    if @task.save
      redirect_to root_path, notice: "タスクを作成しました"
    else
      flash.now[:alert]="タスク登録に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @task = Task.find(params[:id])
  end

  def edit
  end

  def update
    if @task.update(task_params_by_role)
      redirect_to root_path, notice: "タスクを更新しました"
    else
      flash.now[:alert] = "タスクの更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to created_tasks_path, notice: "タスクを削除しました", status: :see_other
  end

  def created
    if user_signed_in?
      @created_parent_tasks = current_user.created_tasks.includes(:assignee, sub_tasks: :assignee)

      @created_sub_tasks = SubTask.where(user_id: current_user.id).includes(:task)

      @all_created_tasks =(@created_parent_tasks + @created_sub_tasks).uniq

      if params[:sukima].present?
        @all_created_tasks =@all_created_tasks.select { |t| t.fit_in_time?(params[:sukima]) }
      end

      @created_todo_tasks =@all_created_tasks.select { |t| t.status == "未着手" }
      @created_doing_tasks =@all_created_tasks .select { |t| t.status == "進行中" }
      @created_done_tasks =@all_created_tasks .select { |t| t.status == "完了" }
    end
  end

  private

  def set_task
    if current_user.admin? || current_user.guest?
      @task = Task.find(params[:id])
    else
      @task = Task.where(user_id: current_user.id)
                .or(Task.where(assignee_id: current_user.id))
                .find(params[:id])
    end
  end

  def task_params
    params.require(:task).permit(
      :assignee_id,
      :title,
      :status,
      :priority,
      :estimated_minutes,
      :due_date,
      :assigned_date,
      :started_at,
      :completed_at,
      :comment

    )
  end

  def task_params_by_role
    if @task.user_id == current_user.id
      task_params
    else
      params.require(:task).permit(
        :status,
        :estimated_minutes,
        :comment
      )
    end
  end
end
