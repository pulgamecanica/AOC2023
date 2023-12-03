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

list_of_engine_numbers = []
file_data.each_with_index do |line, y|
  i = 0
  while i < line.length
    start_i = i
    i += 1 while i < line.length and "0123456789".include?(line[i])
    if line[start_i...i].to_i != 0 
      element = EngineNumber.new(line[start_i...i].to_i)
      neighbors = get_neighbors(line.length, file_data.length, start_i, y, i - start_i)
      neighbors.each { |n| element.neighbors.push(file_data[y + n[0]][start_i + n[1]]) }
      list_of_engine_numbers.push(element)
    end
    i += 1
  end
end 

res = list_of_engine_numbers.sum { |elem| elem.partNumber? ?  elem.value : 0}
puts "Result : #{res}"
