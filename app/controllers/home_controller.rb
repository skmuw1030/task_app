class HomeController < ApplicationController
  def index
    if user_signed_in?
      @tasks = current_user.assigned_tasks.includes(:creator)
    end
  end
end
