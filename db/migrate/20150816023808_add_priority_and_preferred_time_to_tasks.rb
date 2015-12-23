class AddPriorityAndPreferredTimeToTasks < ActiveRecord::Migration
  def change
    change_table :tasks do |t|
      t.integer :priority # 1 being low, 10 being high
      t.string :preferred_time, default: 'none' # morning, afternoon, night, none
    end
  end
end