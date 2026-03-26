class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :assignee_id, index: true
      t.string :title, null: false
      t.string :status, null: false, default: "未着手"
      t.string :priority, null: false, default: "中"
      t.integer :estimated_minutes
      t.date :due_date
      t.date :assigned_date
      t.date :started_at
      t.date :completed_at
      t.boolean :has_missing_docs, null: false, default: false
      t.text :missing_doc_memo
      t.string :missing_doc_requested_to
      t.date :missing_doc_requested_date
      t.text :comment

      t.timestamps
    end
    add_foreign_key :tasks, :users, column: :assignee_id
  end
end
