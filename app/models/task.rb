class Task < ActiveRecord::Base
  include Speech

  def self.remind_random_incomplete
    task = self.not_completed.shuffle.first
    return nil unless task

    message = "You have to #{task.description} for #{task.minutes - task.completed} more minutes today. Why not work on that now?"
    say(message)

    return message
  end

  def self.not_completed
    self.where('completed < minutes')
  end

  def self.clear_completed
    self.all.each { |t| t.update_attributes(completed: 0) }
  end
end
