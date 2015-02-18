class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :description
      t.integer :minutes
      t.integer :completed, default: 0

      t.timestamps
    end
  end
end
