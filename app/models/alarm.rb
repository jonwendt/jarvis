# Save alarms in the correct local time but with the UTC timezone, so it is not changed when saved. Schedules using the current date
# in time zone, plus the hours and minutes of the alarm time, so it will be correct when scheduled.

class Alarm < ActiveRecord::Base
  include Speech
  require 'sidekiq/api'

  belongs_to :user

  acts_as_taggable_on :moods

  after_save { self.class.schedule_alarms }

  def play_message
    if self.message.blank?
      message = self.user.personality.messages.tagged_with(self.user.personality.mood_list, any: true).shuffle.first.build_text(self.title)
    else
      message = self.message
    end

    say(message)
    say_time
    return message
  end

  def self.schedule_alarms
    Sidekiq::ScheduledSet.new.clear # TODO - Only clear scheduled alarms tasks
    alarms = Alarm.where("days = 'ALL'") # Implement days as string
    alarms.each do |alarm|
      time = Date.today.in_time_zone + alarm.time.hour.hours + alarm.time.min.minutes
      AlarmBellJob.perform_at(time, alarm.id)
    end
  end
end
