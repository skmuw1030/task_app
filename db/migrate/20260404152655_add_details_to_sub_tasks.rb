class AddDetailsToSubTasks < ActiveRecord::Migration[7.2]
  def change
    add_column :sub_tasks, :priority, :string, null: false, default: "中"
    add_column :sub_tasks, :estimated_minutes, :integer
  end
end
