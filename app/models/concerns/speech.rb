module Speech
  def say(message)
    `#{Rails.root.join('bin')}/speech.sh "#{message}"`
  end
end