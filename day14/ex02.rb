input = File.readlines('data.txt', chomp: true)
test_input = <<-EOT
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
EOT

input = test_input.split("\n")

def let_it_fall(map, x, y)
  y_after = y - 1
  while y_after != -1
    break if "#O".include?(map[y_after][x])
    y_after -= 1
  end
  map[y_after + 1][x] = "O"
end

def get_rotated_map(matrix)
  matrix.map { |e| e.split("") }.transpose.map(&:reverse).map { |x| x.join("") }
end

height = input.length
width = input[0].length

cycles = 10**9
cycle_maps = {}
cycle = 0
while cycle < cycles
  cycle += 1
  puts "Cycle: #{cycle}"
  4.times do
    tilted = input.map { |s| s.gsub("O", ".") }
    (height * width).times do |i|
      let_it_fall(tilted, i % width, i / height) if input[i / height][i % width] == "O"
    end
    input = get_rotated_map(tilted)
  end
  if cycle_maps.has_key?(input)
    cycle_length = cycle - cycle_maps[input]
    amt = (cycles - cycle) / cycle_length
    cycle += amt * cycle_length
  end
  cycle_maps[input] = cycle
end

total = 0
input.each_with_index do |t, i|
  total += t.count("O") * (height - i)
end

puts "Total: #{total}"
