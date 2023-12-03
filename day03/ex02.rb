file_path = File.expand_path("./../data.txt", __FILE__)
input     = File.read(file_path)
file_data = input.split("\n")

class EngineNumber
  attr_reader :value, :neighbors

  def initialize(value)
    @value = value
    @neighbors = []
  end

  def partNumber?
    return (@neighbors.filter { |neighbor| not ".0123456789".include?(neighbor) }).any?
  end
end

class Gear
  attr_reader :x, :y, :engine_numbers

  def initialize(x, y)
    @x = x
    @y = y
    @engine_numbers = []
  end

  def valid?
    return (@engine_numbers.filter { |neighbor| neighbor.partNumber? }).size == 2
  end

  def part_numbers_neighbors_product
    if valid?
      a = @engine_numbers.filter { |neighbor| neighbor.partNumber? }
      return a[0].value * a[1].value
    end
    return 0
  end
end

def get_neighbors(width, height, x, y, len)
  neighbors = []

  neighbors.push([0, -1])   if x > 0
  neighbors.push([0, len])  if x + len < width - 1
  [1, -1].each do |direction|
    (-1..len).each do |to_east|
      neighbors.push([direction, to_east]) if (y + direction >= 0 && y + direction < height) and (x + to_east > 0 && x + to_east < width - 1)
    end
  end
  return neighbors
end

gears = []
file_data.each_with_index do |line, y|
  i = 0
  while i < line.length
    start_i = i
    i += 1 while i < line.length and "0123456789".include?(line[i])
    if line[start_i...i].to_i != 0 
      element = EngineNumber.new(line[start_i...i].to_i)
      neighbors = get_neighbors(line.length, file_data.length, start_i, y, i - start_i)
      neighbors.each do |n|
        element.neighbors.push(file_data[y + n[0]][start_i + n[1]])
        if file_data[y + n[0]][start_i + n[1]] == "*"
          gear = gears.find {|gear| gear.x == start_i + n[1] && gear.y == y + n[0]}
          if (gear.nil?)
            gear = Gear.new(start_i + n[1], y + n[0])
            gears.push(gear)
          end
          gear.engine_numbers.push(element)
        end
      end
    end
    i += 1
  end
end 

res = gears.sum { |gear| gear.valid? ? gear.part_numbers_neighbors_product : 0}
puts "Result : #{res}"
