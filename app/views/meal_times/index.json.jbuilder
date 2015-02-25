json.array!(@meal_times) do |meal_time|
  json.extract! meal_time, :id
  json.url meal_time_url(meal_time, format: :json)
end
