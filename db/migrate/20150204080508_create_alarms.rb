class CreateAlarms < ActiveRecord::Migration
  def change
    create_table :alarms do |t|
      t.time :time
      t.string :message
      t.string :days

      t.timestamps
    end
  end
end
