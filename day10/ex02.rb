input = File.readlines('data.txt', chomp: true)
test_input = <<-EOT
..F7.
.FJ|.
SJ.L7
|F--J
LJ...
EOT

# | is a vertical pipe connecting north and south.
# - is a horizontal pipe connecting east and west.
# L is a 90-degree bend connecting north and east.
# J is a 90-degree bend connecting north and west.
# 7 is a 90-degree bend connecting south and west.
# F is a 90-degree bend connecting south and east.
# . is ground; there is no pipe in this tile.
# S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.

input = test_input.split("\n")

class Pipe
  attr_reader :connection1, :connection2, :coordinates, :steps_away

  def initialize(type, coordinates)
    @coordinates = coordinates
    @steps_away = 0
    case type
    when "|"
      @connection1 = [0, 1]
      @connection2 = [0, -1]
      break
    when "-"
      @connection1 = [1, 0]
      @connection2 = [-1, 0]
      break
    when "L"
      @connection1 = [0, 1]
      @connection2 = [1, 0]
      break
    when "J"
      @connection1 = [0, 1]
      @connection2 = [-1, 0]
      break
    when "7"
      @connection1 = [0, -1]
      @connection2 = [-1, 0]
      break
    when "F"
      @connection1 = [0, -1]
      @connection2 = [1, 0]
      break
    end
  end
end

animal = nil
pipes = []
input.each_with_index do |line, y|
  line.split("").each_with_index do |c, x|
    if (c == "S")
      animal = [x, y]
    elsif (c != ".")
      pipes.push(Pipe.new(type, [x, y]))
  end
end

puts pipies
