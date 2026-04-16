class SubTasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [ :new, :create ]

  def new
    @sub_task = @task.sub_tasks.build
  end

  def create
    @sub_task = @task.sub_tasks.build(sub_task_params)
    @sub_task.creator = current_user

    if @sub_task.save
      redirect_to root_path, notice: "依頼タスクを追加しました", status: :see_other
    else
      flash.now[:alert]="依頼タスク登録に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_task
    @task = Task.where(user_id: current_user.id)
                .or(Task.where(assignee_id: current_user.id))
                .find(params[:task_id])
  end



  private

  def sub_task_params
    params.require(:sub_task).permit(
      :assignee_id,
      :title,
      :status,
      :due_date,
      :note,
      :priority,
      :estimated_minutes
    )
  end
end
