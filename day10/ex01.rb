input = File.readlines('data.txt', chomp: true)
test_input = <<-EOT
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L
EOT

class String
def blue;           "\e[34m#{self}\e[0m" end
def magenta;        "\e[35m#{self}\e[0m" end
def bg_gray;        "\e[47m#{self}\e[0m" end
end

# | is a vertical pipe connecting north and south.
# - is a horizontal pipe connecting east and west.
# L is a 90-degree bend connecting north and east.
# J is a 90-degree bend connecting north and west.
# 7 is a 90-degree bend connecting south and west.
# F is a 90-degree bend connecting south and east.
# . is ground; there is no pipe in this tile.
# S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.

# input = test_input.split("\n")

class Pipe
  attr_reader :connections, :position, :steps_away, :type

  def initialize(type, position)
    @position = position
    @steps_away = 0
    @connections = []
    @type = type

    @connections.push(position[0] - 1, position[1]) if ("|LJ".include?(type)) # North
    @connections.push(position[0] + 1, position[1]) if ("|7F".include?(type)) # South
    @connections.push(position[0], position[1] + 1) if ("-LF".include?(type)) # East
    @connections.push(position[0], position[1] - 1) if ("-J7".include?(type)) # West
  end
end

animal = nil
pipes = {}
input.each_with_index do |line, y|
  line.split("").each_with_index do |c, x|
    if (c == "S")
      animal = [x, y]
    elsif (c != ".")
      pipes[[x, y]] = Pipe.new(c, [x, y - 1])
    end
  end
end


def get_box_char(type)
  case type
  when "|"
    return "│"
  when "-"
    return "─"
  when "L"
    return "└"
  when "J"
    return "┘"
  when "7"
    return "┐"
  when "F"
    return "┌"
  end
end

input.each_with_index do |line, y|
  line.split("").each_with_index do |c, x|
    if (c == "S")
      print "▓".magenta.bg_gray
    elsif (c != ".")
      print get_box_char(c).blue.bg_gray
    else
      print " "
    end
  end
  puts
end