class Personality < ActiveRecord::Base
  belongs_to :user
  has_many :messages
  
  acts_as_taggable_on :moods
end
