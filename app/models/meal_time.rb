class MealTime < ActiveRecord::Base
  include Speech

  def random_recipe
    # Recipe.where(type: self.type).shuffle.first # Breakfast, Lunch, Dinner, Snack
    recipes = Net::HTTP.start 'rss.allrecipes.com'
    recipes.get('/daily.aspx?hubID=80') # Parse as xml, then choose an item, listing the others on "today's meals"
    return Recipe.first
  end

  def recipe
    Recipe.find(self.recipe_id)
  end

  def play_message
    message = "Time for #{self.name}! The time is #{self.time}, so how about making #{self.recipe.name}. That is not a suggestion. Do it. Or else."
    say(message)

    return message
  end

  def self.schedule_meal_times
    meal_times = MealTime.all
    meal_times.each do |meal_time|
      meal_time.update_attribute(:recipe_id, meal_time.random_recipe.id)
      time = Date.today.in_time_zone + meal_time.time.hour.hours + meal_time.time.min.minutes
      MealTimeJob.perform_at(time, meal_time.id)
    end
  end
end
