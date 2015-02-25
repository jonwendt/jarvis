class MealTimeJob
  include Sidekiq::Worker

  def perform(id)
    meal_time = MealTime.find(id)
    meal_time.play_message
  end
end