class CreateAlarms < ActiveRecord::Migration
  def change
    create_table :alarms do |t|
      t.time :time, required: true
      t.string :message
      t.string :days, default: 'ALL'

      t.timestamps
    end
  end
end
