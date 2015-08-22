class Task < ActiveRecord::Base
  include Speech

  belongs_to :user

  serialize :preferred_time

  def self.remind_random_incomplete
    incomplete_task = self.not_completed.shuffle.first
    return nil unless incomplete_task

    message = "#{incomplete_task.description} for #{incomplete_task.minutes - incomplete_task.completed} minutes."
    say(message)

    return message
  end

  # TODO - schedule a job to remind X number of minutes before midnight, X being the sum of the uncompleted minutes of tasks.
  def self.remind_all_incomplete
    incomplete_tasks = self.not_completed
    all_tasks_count = self.count

    if all_tasks_count == incomplete_tasks.count
      message = "Come on, man. You haven't told me that you've completed a task all day. Either you're not using me as I was designed to be used, or you are a lazy piece of shit. So which is it? Did you offend me? Or yourself?"
    elsif incomplete_tasks.count > 0
      message = "You still have some incomplete tasks for today! You only have an hour left to do them, so check on the tasks page for what you need to do."
    end

    say(message)

    return message
  end

  def self.not_completed
    self.where('completed < minutes')
  end

  def self.clear_completed
    self.all.each { |t| t.update_attributes(completed: 0) }
  end

  def self.preferred_times
    ['none', 'morning', 'afternoon', 'evening']
  end
end
