class Task < ActiveRecord::Base
  include Speech

  def self.remind_random_imcomplete
    task = self.not_completed.shuffle.first
    message = "You have to #{task.description} for #{task.minutes - task.completed} more minutes today. Why not work on that now?"
    say(message)

    return message
  end

  def self.not_completed
    self.where('completed < minutes')
  end
end
