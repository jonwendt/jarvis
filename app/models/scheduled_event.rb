class ScheduledEvent < ActiveRecord::Base
  belongs_to :user
  belongs_to :schedule
  belongs_to :event, polymorphic: true
end
