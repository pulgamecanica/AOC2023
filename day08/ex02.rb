input = File.readlines('data.txt', chomp: true)
test_input = <<-EOT
LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)
EOT
# input = test_input.split("\n")

class Node
  attr_reader :left, :right

  def initialize(left, right)
    @left, @right = left, right
  end
end

def dist(first, last, map, instructions, start_check=0)
  count = 0
  while (first[start_check..] != last[start_check..])
    if (instructions[count % instructions.length] == "R")
      first = map[first].right
    elsif (instructions[count % instructions.length] == "L")
      first = map[first].left
    end
    count += 1
  end
  count
end

map = {}
instructions = input[0].split("")
input.each do |line|
  next if line.index("=").nil?
    
  value, tmp = line.split(" = ")
  left, right = tmp.delete("()").split(", ")
  map[value] = Node.new(left, right);
end

current_nodes = map.filter {|key, value| key[-1] == "A" }.map {|key, val| key}
results = current_nodes.map {|node| dist(node, "Z", map, instructions, -1)}
puts results
total = 1
results.each {|r| total = total*r / total.gcd(r)}
puts "Result: #{total}"

