class Admin::BaseController < ApplicationController
  before_action :check_admin

  private

  def check_admin
    unless current_user.admin? || current_user.guest?
      redirect_to root_path, alert: "アクセス権限がありません"
    end
  end
end
