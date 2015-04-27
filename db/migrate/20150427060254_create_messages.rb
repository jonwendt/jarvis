class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :personality_id

      t.string :text
      t.boolean :subject

      t.timestamps
    end
  end
end
