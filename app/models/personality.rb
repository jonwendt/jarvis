class Personality < ActiveRecord::Base
  has_many :messages
  
  acts_as_taggable_on :moods
end
