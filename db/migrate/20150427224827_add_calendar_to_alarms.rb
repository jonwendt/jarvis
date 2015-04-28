class AddCalendarToAlarms < ActiveRecord::Migration
  def change
    change_table(:alarms) do |t|
      t.boolean :read_calendar
    end
  end
end
