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


    tasks = self.user.tasks.incomplete

    #blocks
    hours_in_day = self.sleep_time - self.wake_up_time
    block_hours = hours_in_day / 3

    morning = { tasks: tasks.select { |t| t.preferred_time == 'morning' }, minutes: 0 }
    morning[:minutes] = morning[:tasks].map { |t| t.minutes }.reduce(:+) + morning[:tasks].count * 15

    afternoon = { tasks: tasks.select { |t| t.preferred_time == 'afternoon' }, minutes: 0 }
    afternoon[:minutes] = afternoon[:tasks].map { |t| t.minutes }.reduce(:+) + morning[:tasks].count * 15

    evening = { tasks: tasks.select { |t| t.preferred_time == 'evening' }, minutes: 0 }
    evening[:minutes] = evening[:tasks].map { |t| t.minutes }.reduce(:+) + morning[:tasks].count * 15

    anytime_tasks = tasks.select { |t| t.preferred_time == 'none' }

    anytime_tasks.each do
      if morning[:minutes] <= block_hours * 60
        morning[:tasks] << anytime_tasks.shift
        morning[:minutes] += morning[:tasks].last.minutes + 15
      elsif afternoon[:minutes] <= block_hours * 60
        afternoon[:tasks] << anytime_tasks.shift
        afternoon[:minutes] += afternoon[:tasks].last.minutes + 15
      elsif evening[:minutes] <= block_hours * 60
        evening[:tasks] << anytime_tasks.shift
        evening[:minutes] += evening[:tasks].last.minutes + 15
      end
    end


  end
end
