json.array!(@alarms) do |alarm|
  json.extract! alarm, :id
  json.url alarm_url(alarm, format: :json)
end
