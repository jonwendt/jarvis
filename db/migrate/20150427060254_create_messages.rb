class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :personality_id

      t.string :text
      t.bool :subject

      t.timestamps
    end
  end
end
