class AddStartedAtToSubTasks < ActiveRecord::Migration[7.2]
  def change
    add_column :sub_tasks, :started_at, :date
  end
end
