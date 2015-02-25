class CreateMealTimes < ActiveRecord::Migration
  def change
    create_table :meal_times do |t|
      t.string :name, required: true
      t.time :time, required: true
      t.string :meal_type
      t.integer :recipe_id

      t.timestamps
    end
  end
end
