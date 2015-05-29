class CreateAlarms < ActiveRecord::Migration
  def change
    create_table :alarms do |t|
      t.integer :user_id

      t.time :time, required: true
      t.string :title
      t.string :message
      t.string :days, default: 'ALL'
      t.boolean :read_calendar

      t.timestamps
    end
  end
end
