class Schedule < ActiveRecord::Base
  belongs_to :user
  has_many :alarms
  has_many :meal_times
  has_many :scheduled_events

  after_save :build_schedule

  def build_schedule
    # TODO: Rewrite to use start_time and just add tasks
    # to schedule in order of preferred_time then have buffer time between
    start_time = self.date == Date.today ? self.wake_up_time : Time.now + 5.minutes


    tasks = self.user.tasks.not_completed

    #blocks
    hours_in_day = self.sleep_time - self.wake_up_time
    block_hours = hours_in_day / 3

    morning = { tasks: tasks.select { |t| t.preferred_time == 'morning' }, minutes: 0 }
    morning[:minutes] = morning[:tasks].map { |t| t.minutes }.reduce(:+) + morning[:tasks].count * 15 unless morning[:tasks].empty?

    afternoon = { tasks: tasks.select { |t| t.preferred_time == 'afternoon' }, minutes: 0 }
    afternoon[:minutes] = afternoon[:tasks].map { |t| t.minutes }.reduce(:+) + morning[:tasks].count * 15 unless afternoon[:tasks].empty?

    evening = { tasks: tasks.select { |t| t.preferred_time == 'evening' }, minutes: 0 }
    evening[:minutes] = evening[:tasks].map { |t| t.minutes }.reduce(:+) + morning[:tasks].count * 15 unless evening[:tasks].empty?

    anytime_tasks = tasks.select { |t| t.preferred_time == 'none' }

    anytime_tasks.each do |task|
      if morning[:minutes] <= block_hours * 60
        morning[:tasks] << task
        morning[:minutes] += task.minutes
        self.scheduled_events.create(time: start_time + morning[:minutes], user_id: self.user_id, event: task)
      elsif afternoon[:minutes] <= block_hours * 60
        afternoon[:tasks] << task
        afternoon[:minutes] += task.minutes
        self.scheduled_events.create(time: start_time + block_hours + afternoon[:minutes], user_id: self.user_id, event: task)
      elsif evening[:minutes] <= block_hours * 60
        evening[:tasks] << task
        evening[:minutes] += task.minutes
        self.scheduled_events.create(time: start_time + block_hours * 2 + evening[:minutes], user_id: self.user_id, event: task)
      end
    end

  end
end
