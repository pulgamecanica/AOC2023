file_path = File.expand_path("./../data.txt", __FILE__)
input     = File.read(file_path)
file_data = input.split("\n")

class Race
  attr_reader :dist, :time, :num_possible_winners


  def initialize(dist, time)
    @time = dist
    @dist = time
    @num_possible_winners = 0

    time.to_i.times do |n|
      t = dist / n # Time, if pressed n seconds, distance
      total_race_time = t + n
      if (total_race_time < time)
        @num_possible_winners += 1
      end
    end

  end
end

times = file_data.first.split(": ").last.split(" ").map { |e|  e.to_f }
distances = file_data.last.split(": ").last.split(" ").map { |e| e.to_f }
races = []

times.zip(distances).each do |time, dist|
  races.push(Race.new(dist, time))
end

sum = 1
races.each do |r|
  sum *= r.num_possible_winners
end

puts "Result #{sum}"
