input = File.readlines('data.txt', chomp: true)

# seed-to-soil map:
# 50 98 2
# 52 50 48

# soil-to-fertilizer map:
# 0 15 37
# 37 52 2
# 39 0 15

# fertilizer-to-water map:
# 49 53 8
# 0 11 42
# 42 0 7
# 57 7 4

# water-to-light map:
# 88 18 7
# 18 25 70

# light-to-temperature map:
# 45 77 23
# 81 45 19
# 68 64 13
test_input = <<-EOT
seeds: 79 14 55 13


temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
EOT
test_input = test_input.split("\n")

class Temperature
  attr_reader :humidity
  attr_accessor :value

  def initialize(value, humidity)#, humidity_value)
    @value = value
    @humidity = humidity || Humidity.new(humidity_value)
  end

  def to_s
    "Temperature #{@value}"
  end
end

class Humidity
  attr_reader :temperature
  attr_accessor :value

  def initialize(value, temperature)
    @value = value
    @temperature = temperature || Temperature.new(value)
  end

  def to_s
    "Humidity #{@value} => #{@temperature.to_s}"
  end
end

# class Location
#   attr_reader :humidity
#   attr_accessor :value

#   def initialize(value, humidity)
#     @value = value
#     @humidity = humidity
#   end

#   def to_s
#     "Location #{@value} => Humidity #{@humidity}"
#   end
# end

# class Light
#   attr_accessor :temperature, :value

#   def initialize(value, temperature_value)
#     @value = value
#     @temperature = Temperature.new(temperature_value)
#   end

#   def to_s
#     "Light #{@value} => #{@temperature.to_s}"
#   end
# end

# class Water
#   attr_accessor :light, :value

#   def initialize(value, light_value)
#     @value = value
#     @light = Light.new(light_value)
#   end

#   def to_s
#     "Water #{@value} => #{@light.to_s}"
#   end
# end

# class Fertilizer
#   attr_accessor :water, :value

#   def initialize(value, water_value)
#     @value = value
#     @water = Water.new(water_value)
#   end

#   def to_s
#     "Fertilizer #{@value} => #{@water.to_s}"
#   end
# end

# class Soil
#   attr_accessor :fertilizer, :value

#   def initialize(value, fertilizer_value)
#     @value = value
#     @fertilizer = Fertilizer.new(fertilizer_value)
#   end


#   def to_s
#     "Soil #{@value} => #{@fertilizer.to_s}"
#   end
# end


# class Seed
#   attr_accessor :soil, :value

#   def initialize(value, soil_value)
#     @value = value
#     @soil = Soil.new(soil_value)
#   end


#   def to_s
#     print "Seed #{@value} => #{@soil.to_s}"
#   end

#   def change_dst(value)
#     @soil.change_dst(value)
#     # @value = value
#   end
# end


input = test_input

map_end = 0
maps = []
input.each_with_index do |line, i|
  if (line.include?("map"))
    map_end = i
    while not (input[map_end].nil? or input[map_end].empty?)
      map_end += 1 
    end
    maps.push([line.split(" ")[0], input[(i + 1)...map_end].map { |e| e.split(" ").map { |n| n.to_i } }])
  end
end


seeds_list = input.first.split(": ")[1].split(" ").map { |e| e.to_i }
seeds = {}

# Location
# Humidity
# Temperature
# Light
# Water
# Fertilizer
# Soil
# Seed


locations = {}
maps.last.last.each do |rules|
  src = rules[0]
  dst = rules[1]
  len = rules[2]
  len.times do |i|
    puts "For Location: #{dst + i} => Humidity #{src + i}"
    locations[dst + i] = Location.new(dst + i, Humidity.new(src + i,  nil))
  end
end

humidities = {}
maps[-2].last.each do |rules|
  src = rules[0]
  dst = rules[1]
  len = rules[2]
  len.times do |i|
    puts "For Humidity: #{dst + i} => Temperature #{src + i}"
    humidities[dst + i] = Humidity.new(dst + i, Temperature.new(src + i))

    humidity_location = locations.select {|l| l.humidity.value == dst + i}
    if humidity_location.nil?
      locations[dst + i] = Location.new(dst + i, humidities[dst + i])
    end
  end
end


puts seeds[0]

