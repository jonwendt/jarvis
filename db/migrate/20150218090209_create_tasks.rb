class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :user_id

      t.string :description, required: true
      t.integer :minutes, required: true, default: 15
      t.integer :completed, default: 0

      t.timestamps
    end
  end
end
