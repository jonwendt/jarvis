class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :user_id

      t.date :date
      t.time :wake_up_time, required: true, default: Time.at(10.hours).utc
      t.time :sleep_time, required: true, default: Time.at(24.hours).utc

      t.timestamps
    end
  end
end
