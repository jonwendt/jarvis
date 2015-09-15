class SidekiqHelper
  def self.job_exists?(class_name, args)
    # TODO - Iterate through each args with index, comparing the elements at the same indexes. ProcessDataEventsJob has unpredictable second arg.
    if Sidekiq::Workers.new.to_a.select { |worker| worker.third['payload']['class'] == class_name and worker.third['payload']['args'].first == args.first }.empty?
      return false
    else
      return true
    end
  end
end