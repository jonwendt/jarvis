class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :meal_type
      t.string :link

      t.timestamps
    end
  end
end
