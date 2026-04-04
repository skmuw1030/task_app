class HomeController < ApplicationController
  def index
    if user_signed_in?
      @tasks = current_user.assigned_tasks.includes(:creator)

      @todo_tasks =@tasks.where(status: "未着手")
      @doing_tasks =@tasks.where(status: "進行中")
      @done_tasks =@tasks.where(status: "完了")
    end
  end
end
