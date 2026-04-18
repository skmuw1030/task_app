class HomeController < ApplicationController
  def index
    if user_signed_in?
      @parent_tasks = current_user.assigned_tasks.includes(sub_tasks: :assignee)

      @my_sub_tasks = SubTask.where(assignee_id: current_user.id).includes(:task)


      @all_tasks =(@parent_tasks + @my_sub_tasks).uniq

      if params[:sukima].present?
        @all_tasks =@all_tasks.select { |t| t.fit_in_time?(params[:sukima]) }
      end

      @todo_tasks =@all_tasks.select { |t| t.status == "未着手" }
      @doing_tasks =@all_tasks .select { |t| t.status == "進行中" }
      @done_tasks =@all_tasks .select { |t| t.status == "完了" }
    end
  end
end
