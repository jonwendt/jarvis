class Schedule < ActiveRecord::Base
  belongs_to :user
  has_many :alarms
  has_many :meal_times
  has_many :scheduled_events

  after_save :build_schedule

  def build_schedule
    self.user.tasks.count
  end
end
