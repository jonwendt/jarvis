class AddTitlesToAlarms < ActiveRecord::Migration
  def change
    change_table :alarms do |t|
      t.string :title
    end
  end
end