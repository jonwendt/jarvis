class Personality < ActiveRecord::Base
  belongs_to :user
  has_many :messages
  
  acts_as_taggable_on :moods

  def self.default_moods
    ['Insulting', 'Encouraging', 'Happy', 'Sad']
  end
end
