input = File.readlines('data.txt', chomp: true)
# test_input = <<-EOT
# LLR

# AAA = (BBB, BBB)
# BBB = (AAA, ZZZ)
# ZZZ = (ZZZ, ZZZ)
# EOT
# input = test_input.split("\n")

class Node
  attr_reader :left, :right, :value

  def initialize(value, left, right)
    @value, @left, @right = value, left, right
  end
  def to_s
    "#{value}   <- #{left}   |   #{right} ->"
  end
end

map = {}

instructions = input[0].split("")
input.each do |line|
  next if line.index("=").nil?
    
  value, tmp = line.split(" = ")
  left, right = tmp.delete("()").split(", ")
  map[value] = Node.new(value, left, right);
end


count = 0
current_node = "AAA"
current_instruction = count

while (current_node != "ZZZ")
  if (instructions[count % instructions.length] == "R")
    current_node = map[current_node].right
  elsif (instructions[count % instructions.length] == "L")
    current_node = map[current_node].left
  end
  count += 1
end

puts "NODE: #{current_node}, count: #{count}"

# res = cards.sum {|c| c.get_value}
# puts "Result: #{res}"
