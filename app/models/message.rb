class Message < ActiveRecord::Base
  belongs_to :personality

  acts_as_taggable_on :moods

  def build_text(subject=nil)
    text = self.text.gsub('#{NAME}', (current_user ? current_user.name : ''))
    if subject
      self.text.gsub('#{SUBJECT}', subject)
    else
      self.text
    end
  end

  def current_user
    begin
      return self.personality.user
    rescue
      return nil
    end
  end
end

# Messages should have subject bool. If there is a subject, then 
