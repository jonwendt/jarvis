class CreateScheduledEvents < ActiveRecord::Migration
  def change
    create_table :scheduled_events do |t|
      t.integer :user_id
      t.integer :schedule_id
      t.integer :event_id
      t.string :event_type

      t.time :time, required: true
      t.integer :duration, default: 15 # minutes

      t.boolean :completed, default: false
      t.boolean :ignored, default: false

      t.timestamps
    end
  end
end
