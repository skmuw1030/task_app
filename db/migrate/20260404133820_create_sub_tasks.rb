class CreateSubTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :sub_tasks do |t|
      t.references :task, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :assignee_id, index: true
      t.string :title, null: false
      t.string :status, null: false, default: "未着手"
      t.date :due_date
      t.date :completed_at
      t.text :note

      t.timestamps
    end

    add_foreign_key :sub_tasks, :users, column: :assignee_id
  end
end
