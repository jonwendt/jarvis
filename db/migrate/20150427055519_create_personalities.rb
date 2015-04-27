class CreatePersonalities < ActiveRecord::Migration
  def change
    create_table :personalities do |t|
      t.integer :user_id

      t.string :name, default: 'Jarvis'

      t.timestamps
    end
  end
end
